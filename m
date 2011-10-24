Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab1JXPXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:23:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46731 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab1JXPXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <m1ipneifqv.fsf@fess.ebiederm.org>
References: <1319468137.3615.16.camel@br98xy6r>
	<m1ipneifqv.fsf@fess.ebiederm.org>
Date: Mon, 24 Oct 2011 23:23:33 +0800
Message-ID: <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: holzheu@linux.vnet.ibm.com, Vivek Goyal <vgoyal@redhat.com>,
        akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:14 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
>
>> Hello Vivek,
>>
>> In our tests we ran into the following scenario:
>>
>> Two CPUs have called panic at the same time. The first CPU called
>> crash_kexec() and the second CPU called smp_send_stop() in panic()
>> before crash_kexec() finished on the first CPU. So the second CPU
>> stopped the first CPU and therefore kdump failed.
>>
>> 1st CPU:
>> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
>>
>> 2nd CPU:
>> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
>>        ->smp_send_stop()-> stop CPU 1 (stop kdump)
>>
>> How should we fix this problem? One possibility could be to do
>> smp_send_stop() before we call crash_kexec().
>>
>> What do you think?
>
> smp_send_stop is insufficiently reliable to be used before crash_kexec.
>
> My first reaction would be to test oops_in_progress and wait until
> oops_in_progress == 1 before calling smp_send_stop.
>

+1

One of my colleague mentioned the same problem with me inside
RH, given the fact that the race condition window is small, it would
not be easy to reproduce this scenario.

Thanks.
