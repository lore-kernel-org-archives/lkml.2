Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1AFTCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:02:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32894 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1AFTCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:02:47 -0500
MIME-Version: 1.0
In-Reply-To: <m1bp3uifln.fsf@fess.ebiederm.org>
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
	<m1bp3uifln.fsf@fess.ebiederm.org>
Date: Thu, 6 Jan 2011 14:02:47 -0500
Message-ID: <AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
From: Eric Paris <eparis@parisplace.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 3:47 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>> Eric pointed out that kexec_load() actually allows you to
>> run any code you want in ring0, this is more like CAP_SYS_MODULE.
>
> Let me get this straight you want to make the permission checks
> less stringent by allowing either CAP_SYS_MODULE or CAP_SYS_BOOT?

Nope, read my patch again.  It actually requires BOTH of them.

> CAP_SYS_BOOT is the correct capability.  Sure you can run any
> code but only after rebooting.  I don't see how this differs
> from any other reboot scenario.

The difference is that after a reboot the bootloader and the system
control what code is run.  kexec_load() immediately runs the new
kernel which is not controlled by the bootloader or by the system.
Imagine a situation where the bootloader and the /boot directory are
RO (enforced by hardware).   kexec_load() would let you run any kernel
code you want on the box whereas reboot would not.

>> Reported-by: Eric Paris <eparis@redhat.com>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>>
>> ---
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>> index b55045b..c30d613 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -945,7 +945,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>>       int result;
>>
>>       /* We only trust the superuser with rebooting the system. */
>> -     if (!capable(CAP_SYS_BOOT))
>> +     if (!capable(CAP_SYS_BOOT) || !capable(CAP_SYS_MODULE))
>>               return -EPERM;
>>
>>       /*
