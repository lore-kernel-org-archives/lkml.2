Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2IYJEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:04:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2IYJEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:04:42 -0400
Message-ID: <506173A6.2050705@canonical.com>
Date: Tue, 25 Sep 2012 11:04:38 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com> <50615268.1040805@canonical.com> <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
In-Reply-To: <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 25-09-12 09:05, Eric W. Biederman schreef:
> Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>
>> Hey,
>>
>> Op 25-09-12 05:39, Eric W. Biederman schreef:
>>> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>>>
>>>> This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.
>>>>
>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>
>>>> My thread about the regression seemed to have been ignored, so I can
>> only
>>>> conclude nobody objects against a full revert of this patch.
>>>>
>>>> My testcase is simply booting through netboot with / and ~/nfs as
>> separate
>>>> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a
>> gnome-terminal
>>>> window, then I get:
>>> Do I read your description correctly:  Without using a bind mount you
>>> have the same nfs filesystem mounted on / and on ~/nfs?
>>>
>>> Something is definitely off with your configuration but if to work
>> you
>>> need to move mount points around then that something seems much
>> deeper
>>> than the __d_unalias change.
>>>
>>> What filesystems do you have mounted where?
>>>
>> / is a nfs filesystem, ~/nfs is a different nfs filesystem.
> Are both filesystems on the same server?
>
> Are the two filesystems distinct filesystem on the server?
>
> Unless there is duplication of something somewhere the d_unalias code should not trigger.

They're both on the same physical filesystem on the server, but unique exports:
/home/mlankhorst/nfs *(no_subtree_check,insecure,rw,all_squash,anonuid=1000,anongid=1000)
/home/mlankhorst/kvm/quantal-amd64 *(no_subtree_check,insecure,rw,no_root_squash)

Rootfs is mounted by the kernel itself, I used a custom init script to mount /lib/modules
early on:

mount -t nfs -o nolock,vers=3 192.168.1.128:/home/mlankhorst/nfs /home/mlankhorst/nfs &&
mkdir -p /lib/modules/$(uname -r)/kernel &&
mount --bind /home/mlankhorst/nfs/linux /lib/modules/$(uname -r)/kernel &&
([ -f /lib/modules/$(uname -r)/modules.symbols ] || depmod)

exec /sbin/init

>> Just doing
>> ls / is enough
>> to make all filesystems mounted on / return -EBUSY and disappear.
>>
>> I also have a subdir of ~/nfs/ bind mounted to /lib/modules/$(uname
>> -r)/kernel
>> for easy debugging so just doing 'make' in the kernel tree is enough to
>> get the
>> new modules + bzImage, but I don't know if it is a factor in
>> reproducing this bug
>> or not.
> Unlikely.  But interesting.  It at least fits the criteria of showing up to different places.  It should not be enough for d_materialise uniqe.
>
Either way until the root cause is found could this patch be reverted?

~Maarten
