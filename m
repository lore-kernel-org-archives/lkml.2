Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab2CAAOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:14:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34460 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab2CAAOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:14:05 -0500
Message-ID: <4F4EBF44.60208@zytor.com>
Date: Wed, 29 Feb 2012 16:13:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz> <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com> <4F4E6B98.2090306@zytor.com> <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com> <4F4EB0B9.2080906@zytor.com> <CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com>
In-Reply-To: <CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 03:51 PM, Joshua C. wrote:
> 
> Will this work?
> 
> +#if (defined(__i386__) || defined(__x86_64__))
> +#include <asm/io.h>
> +#include <asm/setup.h>
> +#else
> +extern struct boot_params boot_params;
> +#endif
> 

A much better way to do this is probably something like

#ifdef CONFIG_X86

#include <asm/setup.h>

static inline int kbd_defleds(void)
{
	return boot_param.kbd_status & 0x20 ? (1 << VC_NUMLOCK) : 0;
}

#elif defined(CONFIG_PARISC)
static inline int kbd_defleds(void)
{
# if defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD)
	return 1 << VC_NUMLOCK;
# else
	return 0;
# endif
}

#else

static inline int kbd_defleds(void)
{
	return 0;
}

#endif

... then arguably this should be moved into the arch/* directories, in a
header file or by making this a callable function.


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

