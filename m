Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1KYSKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 13:10:42 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:40252 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KYSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 13:10:41 -0500
Message-ID: <4ECFDA1D.3090303@grupopie.com>
Date: Fri, 25 Nov 2011 18:10:37 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nuno Santos <nsantos@edigma.com>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com> <4ECFBF56.4000002@edigma.com> <4ECFCAD5.5040606@grupopie.com> <4ECFD488.4060805@edigma.com>
In-Reply-To: <4ECFD488.4060805@edigma.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nuno Santos wrote:
>>[...]
>> Unless you have overflow or need more than 16 bits of fractional
>> precision, you'll have no problem with this approach.
>>
>> I hope this helps,
> Sorry, i'm not sure if I have completely understand your suggestion. Are
> you telling me to apply this transform only to my input data, or to all
> the operations that are applied in the function used in kernel?

Imagine that your matrix coefficients are:

 2.5,     1, 4.7
45.3, 0.765,  10
   0,     0,   1

and your input is:

3420.56, 5410.76, 1

You start by converting the matrix coefficients:

2.5 * 65536.0 = 163840
....

so the matrix becomes:

 163840 65536 308019
2968781 50135 655360
      0     0  65536

This can be done in userspace and the coefficients can be sent to the
kernel as fixed point numbers.

You do the same (this time on the kernel) with your input, so it becomes:

224169820 354599567 65536

Now you can do:

q[0] = fixed_mul(p[0], a[0][0]) + fixed_mul(p[1], a[1][0]) +
fixed_mul(p[2], a[2][0]);
....

where "fixed_mul" is a function that does the multiplication as I
explained earlier.

To convert the result back to an integer, just shift down by 16.

-- 
Paulo Marques - www.grupopie.com

"Feed the hungry, save the whales, free the mallocs!"
