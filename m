Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0LFPkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:40:37 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41789 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0LFPke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mx5OKVyQV+j621oACkZmHcodEGRFKj9BpAmmDXBpNwO8bVJ3N1i/b8luWUQv//TpNR
         Y3CXZ2Xv1Bpo7eGomsYnAkABEC5G84byyQF7glcmFWiE3uVDhtkP3iL5JAG2SwpuBdh0
         hcd/T+0u1MOv/ry7qLL1nM4HahbSxcZW/OCQc=
MIME-Version: 1.0
In-Reply-To: <20101206073513.54ca2c71@tlielax.poochiereds.net>
References: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
	<20101203094844.68f2bc40.randy.dunlap@oracle.com>
	<20101206070956.GA5570@elte.hu>
	<20101206073513.54ca2c71@tlielax.poochiereds.net>
Date: Mon, 6 Dec 2010 09:40:33 -0600
Message-ID: <AANLkTimTFi6jji5wmnBTT25XYAXAhJYNY+YmqhW5McEC@mail.gmail.com>
Subject: Re: linux-next: Tree for December 3 (cifs)
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
        Steve French <sfrench@samba.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 6:35 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Mon, 6 Dec 2010 08:09:56 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> > On Fri, 3 Dec 2010 13:04:40 +1100 Stephen Rothwell wrote:
>> >
>> > > Hi all,
>> > >
>> > > Changes since 20101202:
>> >
>> >
>> > When CIFS_EXPERIMENTAL is not enabled:
>> >
>> > (.text+0xdf6c9): undefined reference to `get_cifs_acl'
>> >
>> > from fs/cifs/xattr.c:cifs_getxattr()
>> >
>> >
>> > CONFIG_CIFS=y
>> > # CONFIG_CIFS_STATS is not set
>> > CONFIG_CIFS_WEAK_PW_HASH=y
>> > # CONFIG_CIFS_UPCALL is not set
>> > CONFIG_CIFS_XATTR=y
>> > CONFIG_CIFS_POSIX=y
>> > # CONFIG_CIFS_DEBUG2 is not set
>> > # CONFIG_CIFS_DFS_UPCALL is not set
>> > CONFIG_CIFS_FSCACHE=y
>> > CONFIG_CIFS_ACL=y
>> > # CONFIG_CIFS_EXPERIMENTAL is not set
>>
>> And this build regression has been pushed upstream now, as of:
>>
>>    8520eeaa1235: Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
>>
>> and it is triggering for me too:
>>
>>    fs/built-in.o: In function `cifs_getxattr':
>>    (.text+0xc518e): undefined reference to `get_cifs_acl'
>>
>> The regression got introduced by:
>>
>>    fbeba8bb16d7: cifs: Handle extended attribute name cifs_acl to generate cifs acl blob (try #4)
>>
>> Which introduced the new CIFS_ACL option.
>>
>> Thanks,
>>
>>       Ingo
>
> Yeah, looks like this new Kconfig option depends on some code that's
> under the (much-overloaded) CIFS_EXPERIMENTAL Kconfig option. I think
> this patch needs some rework. The simple fix would be to make it
> dependent on CIFS_EXPERIMENTAL, but that's rather icky since

Making CONFIG_CIFS_ACL dependent on CONFIG_CIFS_EXPERIMENTAL
works

 config CIFS_ACL
          bool "Provide CIFS ACL support (EXPERIMENTAL)"
-         depends on EXPERIMENTAL && CIFS_XATTR
+         depends on CIFS_EXPERIMENTAL && CIFS_XATTR
          help
            Allows to fetch CIFS/NTFS ACL from the server.  The DACL blob
            is handed over to the application/caller.

At the minimum function find_readable_file() and three functions
in cifssmb.c would not have to be in CIFS_EXPERIMENTAL.
And we would need to move some other cifs acl related functions
from under CIFS_ACL from CIFS_EXPERIMENTAL.

> CIFS_EXPERIMENTAL pulls in some rather broken stuff...
>
> --
> Jeff Layton <jlayton@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
