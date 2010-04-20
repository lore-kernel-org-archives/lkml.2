Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0DTPxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:53:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36656 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DTPxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hbyqo7QRmPPQbEUvkSczNkUEBHWZ+ImScCvhul9ZJNxdD81x+GSGDEZBSNNpOyDJBa
         rWwxjFpPkvQ+qq95JhmE2eZdJfWZKICstoE/Dmt6EhVohygWlRy8MosjfrrJOo6u6UeG
         vJE/Wt9P33iiKvgZGRfm3TnhVes8wKBWAoUiw=
MIME-Version: 1.0
In-Reply-To: <1271777652.30027.131.camel@moss-pluto.epoch.ncsc.mil>
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com> 
	<n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com> 
	<20100419213952.GA28494@hallyn.com> <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil> 
	<v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com> 
	<1271777652.30027.131.camel@moss-pluto.epoch.ncsc.mil>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 20 Apr 2010 11:53:29 -0400
X-Google-Sender-Auth: bb5c28d5a551edb1
Message-ID: <s2pcb0375e11004200853m62ee45b5lf447da1e1a55ffc5@mail.gmail.com>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:34 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>> True,  but I think it's still asking for trouble -- other LSMs could
>> (and almost certainly will, especially the out-of-tree ones) do
>> something, and I think that any action at all that an LSM takes in the
>> bprm_set_creds hook for a nosuid (or whatever it's called) process is
>> wrong or at best misguided.
>>
>> Can you think of anything that an LSM should do (or even should be
>> able to do) when a nosuid process calls exec, other than denying the
>> request outright?  With my patch, LSMs can still reject the open_exec
>> call.
>
> In the case where the context transition would shed permissions rather
> than gain permissions, it has been suggested that we shouldn't disable
> the transition even in the presence of nosuid.  But automatically
> computing that for a domain transition is non-trivial, so we have the
> present behavior for SELinux.
>
> There also can be state updates even in the non-suid exec case, e.g.
> saved uids, clearing capabilities, etc.

Ah, right.

In my patch, execve_nosecurity is (or will be, anyway) documented to
skip all of this, and it's a new syscall, so nothing should need to be
done.  It doesn't allow anything that a userland ELF loader couldn't
already do.  (I'm not thrilled with changing the behavior of the
original execve syscall, but one way or another, any nosuid mechanism
will probably allow programs to exec other things without losing
permissions that the admin might have expected.  I don't see this is a
real problem, though.)

Is it even possible to purely drop permissions in SELinux?  If your
original type was orig_t and your new type is new_t, and if the rights
granted to orig_t and new_t overlap nontrivially, then what are you
supposed to do?  Check both types for each hook?  (Some annoying admin
could even *change* the rights for orig_t or new_t after execve
finishes.)

>
> But as far as the access control goes, it should suffice to check read
> and execute access to the file, just as with the userland ELF loader
> scenario (which gets handled by the mmap hook).
>
> --
> Stephen Smalley
> National Security Agency
>
>
