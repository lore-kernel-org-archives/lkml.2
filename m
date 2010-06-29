Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0F2Wav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:30:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42536 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab0F2Wau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:30:50 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2010 18:30:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PaIBHRck6PKjdsqh1iQ06e0ZeGtVy894Xy6dUx0eTECmQoDmx7IzD4F8XLR++nCv+4
         2eS3iGbaDTv1N2MiOuZ0SCAQoCj33jGWChDGp7XHcBmE3GeySmR4v+4PUcLq51rnQIdF
         Jcwt7/Zh903E0kmZWiaGh2xUvw22Ar0E7Vmsw=
MIME-Version: 1.0
In-Reply-To: <AANLkTineRed7JZIwIP8SQYm5uj5vrO1s1_wP-KyR4Tiy@mail.gmail.com>
References: <AANLkTila2rrYcBUZKwywHTP6g8rsj7Z1ck6LSoC9GaUY@mail.gmail.com>
	<AANLkTikbQLTC8HLB2m8LoPtZ0JVUzRl6PvRL5yTC0pZV@mail.gmail.com>
	<1277496077.6141.30.camel@heimdal.trondhjem.org>
	<AANLkTikH-jOOOzJ7xium-O3jwHpgh_czAFlkFkwnxpkK@mail.gmail.com>
	<1277499572.6141.46.camel@heimdal.trondhjem.org>
	<AANLkTimOiRTaGLBhPWiyRfBaC4Pau5DDK7zV_2_MNMJu@mail.gmail.com>
	<1277502630.6141.57.camel@heimdal.trondhjem.org>
	<AANLkTinAzT7lrFpnZWOhjHxYNYqV2e-cv3NqNSs8_p1y@mail.gmail.com>
	<1277506467.6141.64.camel@heimdal.trondhjem.org>
	<AANLkTimV4yABFKQQYqsk87j3oDu1P0ugh0uUTl4berBp@mail.gmail.com>
	<5970B547-E179-4FBD-B23B-0FA1C135C408@fys.uio.no>
	<AANLkTineRed7JZIwIP8SQYm5uj5vrO1s1_wP-KyR4Tiy@mail.gmail.com>
Date: Tue, 29 Jun 2010 15:23:21 -0700
Message-ID: <AANLkTim-GJ9ObZ19jriNvAxMYNZ2JdKGxVRVE53emNvr@mail.gmail.com>
Subject: Fwd: fs/exec.c core dumping on NFS mounted directory
From: Lei Sun <leisun124@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trond.myklebust@fys.uio.no
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>>
>>>>>> The fixing of Bug-3043 clearly broke the logic of dumping core on NFS
>>>>>> mounted file system with different UID.
>>>>>> If my patch is not accepted. I am hopping the bug-3043 to be
>>>>>> re-opened. and to be fixed
>>>>>
>>>>> Using different uids on the client and server for NFSv2 and NFSv3 is a
>>>>> broken setup. Don't do it.
>>>>> The only way such a NFS client can be sure that the file was really
>>>>> created by itself would be to use an exclusive create. That would break
>>>>> if the file 'core' already exists, though.
>>>>>
>>>>> Can't you use NFSv4 instead? If set up correctly, that will allow you to
>>>>> use different uid and gid mappings on the client and server (provided
>>>>> that the user name and group names are the same).
>>>>>
>>>>>
>>>>>
>>>>>
>>>> NFS mount is just one problem out of other potential breaks. We are
>>>> working on embedded Linux and mount to company filer via NFS and
>>>> observed this issue. Even I could change the NFS server(Not to mention
>>>> that we have a big IT department handles it), other people could still
>>>> see the problems.
>>>>
>>>> The checking of "inode->i_uid != current_fsuid" could break in :
>>>>
>>>> 1) NFS mount using root_squash: if current_fsuid() == 0, inode->i_uid
>>>> will be nonzero.  Very common in embedded development.
>>>
>>> Definitely a case where you want to _disallow_ core dumping. The
>>> resulting core dump is owned by someone other than the process that
>>> created it.
>>>
>>>> 2) Writable VFAT mount (e.g. umask=0): current_fsuid() might not match
>>>> the filesystem ownership, so a process that has permission to write to a
>>>> directory still can't dump core there.  On embedded platforms the VFAT
>>>> filesystem is likely to reside on an SDHC/eMMC card, USB flash drive,
>>>> external HDD, etc.
>>>
>>> Ditto.
>>>
>>>> 3) Host is using 32-bit UIDs, but the filesystem can only handle 16-bit
>>>> UIDs.  current_fsuid() may not match inode->i_uid in the case of overflow.
>>>
>>> Ditto.
>>>
>>>
>>
>> I really don't understand in all above 3 case, why am I not allowed to
>> dumping core...
>> Taking NFS mount as an example.
>> Yes, the process will dump out core file owned by other user. So will
>> be the "copy file over to NFS directory. Should it disallow copying
>> local file to NFS directory as well? if the NFS doesn't preserve the
>> original UID/GID?
>>
>> So you are saying, it is not a bug, it is expected behavour, e.g. I
>> can't dump core on above 3 cases?
>
> Yes
>
>> Although I don't see any security
>> threat of dumping core on NFS/USB and owned by other user.
>
> The security threat lies in the fact that core files are a memory dump. They can contain all sorts of information, such as passwords, ssl session data, ssh keys, private emails, etc. Stuff that you might not want to expose to other people.
>
> Trond

I understand the security concern. The original fix was for general cases.
What I am asking is "is it legitimate thing to do for a root user
process to dump core file on NFS directory?", there are two cases:

1. The NFS server doesn't change the UID/GID, in this case, the
current kernel allow dumping core over NFS.
2. The NFS server does change UID/GID, in this case the current kernel
doesn't allow core dumping.

So current kernel didn't answer the question, because it behave
differently based on different NFS server setting.  Vital information
is not protected for case #1, isn't it?

Hi Trond:
   Any more comments on the question above?

Thanks
