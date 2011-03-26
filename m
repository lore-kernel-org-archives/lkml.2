Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab1CZVn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 17:43:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1CZVn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 17:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=sMxYybmtZMYEFQDmTFMiTFtVrc/zKcud8aBTr3TmPWd7VNeBaKcW00x5ZlAOTL4ROA
         ajPhiNWU7kYCcoXFVv6OF1xe8e+vRLu8SnW6DvNU+Yae6YoQLsUMYN4nPRUe00SCBnQG
         YBsppuwrsQcEDetf54QsOZ0KQYzrlGR6yqrOw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.35-rc4: mount results with and without MS_SILENT differ
Date: Sat, 26 Mar 2011 22:43:18 +0100
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Roman Borisov <ext-roman.borisov@nokia.com>,
        Alexander Shishkin <virtuoso@slind.org>
References: <201103140520.08737.vda.linux@googlemail.com> <20110324234711.60a6e3c3@katamari>
In-Reply-To: <20110324234711.60a6e3c3@katamari>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103262243.18031.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011 04:47, Chuck Ebbert wrote:
> On Mon, 14 Mar 2011 05:20:08 +0100
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
> It looks like this bug has been there forever.
> 
> This fails:
> > mount -vv --make-rshared mount.shared1               2>&1
> 
> This succeeds:
> > mount -vv --loud --make-rshared mount.shared2               2>&1  # <-HERE
> 
> Failure case uses MS_REC | MS_SHARED | MS_SILENT
> > mount: mount('','mount.shared1','',0x0010c000,''):0
> 
> It succeeds with MS_REC | MS_SHARED
> > mount: mount('','mount.shared2','',0x00104000,''):0
> 
> Looking at do_mount() we see some flags get filtered out before checking
> namespace flags:
> 
>         flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
>                    MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
>                    MS_STRICTATIME);
> 
> Then:
> 
>         else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>                 retval = do_change_type(&path, flags);
> 
> In do_change_type()
> 
>         type = flags_to_propagation_type(flag);
>         if (!type)
>                 return -EINVAL;
> 
> And flags_to_propagation_type() filters out MS_REC before making sure one
> and only one of the propagation type flags is set:
> 
>         int type = flags & ~MS_REC;
> 
>         /* Fail if any non-propagation flags are set */
>         if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>                 return 0;
>         /* Only one propagation flag should be set */
>         if (!is_power_of_2(type))
>                 return 0;
> 
> Looks like the is_power_of_2() test is failing because MS_SILENT is set.
> I'm not sure whether to filter MS_SILENT in the upper or lower function
> though.

We cannot slear out MS_SILENT here:

        flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
                   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
                   MS_STRICTATIME);

Because...

        if (flags & MS_REMOUNT)
                retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
                                    data_page);
        else if (flags & MS_BIND)
                retval = do_loopback(&path, dev_name, flags & MS_REC);
        else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
                retval = do_change_type(&path, flags);
        else if (flags & MS_MOVE)
                retval = do_move_mount(&path, dev_name);
        else
...it needs to propagate into:
                retval = do_new_mount(&path, type_page, flags, mnt_flags,
                                      dev_name, data_page);


I think MS_SILENT can be cleared along with MS_REC in do_change_type() ->
flags_to_propagation_type(), on this line:

-       int type = flags & ~MS_REC;
+       int type = flags & ~(MS_REC | MS_SILENT);


-- 
vda
