Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874Ab1BQFAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:00:04 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33338 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1BQFAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DKjKXVyc7Bi89RjygFkZvzOV90uwlJNv5LgXcRbvVybuktlO04h93tOw2HdHIte7uF
         P+vlxCuC59k1dun4A2ChwXw+B1fV/cYxrIQoIOLNs0jGcbrZR19Vh6HVscIv/JMZ47+w
         CTrh7zScNmxS92HnrxeXDszbZXOU151E2MsLU=
MIME-Version: 1.0
In-Reply-To: <20110216153825.GA18805@elte.hu>
References: <1297867715-20394-1-git-send-email-akinobu.mita@gmail.com>
	<20110216153825.GA18805@elte.hu>
Date: Thu, 17 Feb 2011 14:00:01 +0900
Message-ID: <AANLkTi=eS=mdRQ07EvceP0098_=kj96qRNYeQ0oAduo-@mail.gmail.com>
Subject: Re: [PATCH] x86: use bitmap library functions
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/17 Ingo Molnar <mingo@elte.hu>:
>
> * Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> Use bitmap_set()/bitmap_clear() to fill/zero a region of a bitmap
>> instead of doing set_bit()/clear_bit() each bit.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> ---
>>  arch/x86/kernel/ioport.c |   20 +++++---------------
>>  1 files changed, 5 insertions(+), 15 deletions(-)
>
> Before we can merge this it would be nice to tested this using sys_ioperm(), to make
> sure port IO still gets denied/allowed as expected. You can check /proc/ioperm to
> see which ports are (probably) safe to read: 0x80/0xed is usually safe to
> read/write.

I have tested with this program and there is no difference in behavior
with this patch.

#include <sys/io.h>
#include <stdio.h>
#include <err.h>

int main(void)
{
	unsigned long from = 0xed;
	unsigned long num = 1;
	int ret;
	int i;

	ret = ioperm(from, num, 1);
	if (ret)
		err(1, "ioperm");

	for (i = 0; i < num; i++)
		ret = inb(from + i);

	printf("OK\n");

	ret = ioperm(from, num, 0);
	if (ret)
		err(1, "ioperm");

	printf("will receive a segmentation fault\n");

	ret = inb(from);
	errx(1, "Oops");
}
