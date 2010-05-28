Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab0E1Vi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:38:28 -0400
Received: from science.horizon.com ([71.41.210.146]:44813 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757253Ab0E1Vi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:38:26 -0400
Date: 28 May 2010 17:38:21 -0400
Message-ID: <20100528213821.4351.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: andy.shevchenko@gmail.com, iveqy@iveqy.com
Subject: Re: hex_to_bin speedup
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) First of all, I'd worry about code size far more than speed.
   this is not fast-path code.
2) Second, given that you're already doing a range test,
   the fastest way to perform a tolower() is "c |= 0x20".

Generally it's something like:
int hex_to_bin(char ch)
{
	ch -= '0';
	if ((unsigned char)ch <= 9)
		return ch;
	ch |= 0x20;
	ch -= 'a' - '0';
	if ((unsigned char)ch <= 6)
		return ch+10
	return -1;
}


that produces the even smaller code:
hex_to_bin_or:
        movb    4(%esp), %dl
        subl    $48, %edx
        cmpb    $9, %dl
        movsbl  %dl,%eax
        jbe     .L10
        orl     $32, %edx
        orl     $-1, %eax
        subl    $49, %edx
        cmpb    $6, %dl
        ja      .L10
        movsbl  %dl,%eax
        addl    $10, %eax
.L10:
        ret

