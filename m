Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1KWLwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:52:13 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:54487 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1KWLwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:52:12 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Nov 2011 06:52:11 EST
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.11.3.13847, SQMD Hits: none, rbl
 score: 0(0), apm score: 500, ApmFlags: [NN_LENGTH;
 NN_GMAIL_WITH_XMAILER_ADN; NN_LEGIT_SUMM_400_WORDS; NN_NO_LINK_NMD],
 SQMD: 40e073629dee05613e7d078266c60e81.fuzzy.fzrbl.org, total: 0(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.39930
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=gmail.com;
  b=vYyu/2KiJ9N4oU1DXRVkz0b2zVbkFiWCrm8LNDRCooVXd0JLVajByUYQ0eWiDbsckA/JuRxRx0BF/LTq+MQIH1cIob7sqMv8ipVvki5iCfBEUmREP3dZqLMlzGJAdf1vpsECCkXwcn7bleZSYuIwDzc8jHLKp5UEwamRJg8dfj8=  ;
Date: Wed, 23 Nov 2011 13:45:29 +0200
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: "N. Coesel" <nico@nctdev.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fast memcpy patch
Message-ID: <20111123134529.1fb13e13@mdontu-dell.dsd.ro>
In-Reply-To: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
References: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
Organization: Home
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 12:25:46 +0100 N. Coesel wrote:
> Dear readers,
> I noticed the Linux kernel still uses a byte-by-byte copy method for 
> memcpy. Since most memory allocations are aligned to the integer size 
> of a cpu it is often faster to copy by using the CPU's native word 
> size. The patch below does that. The code is already at work in many 
> 16 and 32 bit embedded products. It should also work for 64 bit 
> platforms. So far I only tested 16 and 32 bit platforms.
> 

Could you run checkpatch.pl on this an fix all the warnings? Or, if you
wish, I could do it for you.

> --- lib/string.c.orig   2010-08-20 20:55:55.000000000 +0200
> +++ lib/string.c        2011-11-23 12:29:02.000000000 +0100
> @@ -565,14 +565,47 @@ EXPORT_SYMBOL(memset);
>    * You should not use this function to access IO space, use
> memcpy_toio()
>    * or memcpy_fromio() instead.
>    */
> -void *memcpy(void *dest, const void *src, size_t count)
> +
> +void *memcpy(void *dst, const void *src, size_t length)
>   {
> -       char *tmp = dest;
> -       const char *s = src;
> +       void *p=dst;
> 
> -       while (count--)
> -               *tmp++ = *s++;
> -       return dest;
> +       //check alignment
> +       if (( (int) dst & (sizeof(int) -1)) != ( (int) src & 
> (sizeof(int) -1) ))
> +               {
> +               //unaligned. This will never align so copy
> byte-by-byte
> +               goto copyrest;
> +               }
> +
> +       //seek aligment (lower bits should become 0). Because
> +       //we already tested the lower bits are equal, we only need
> +       //to test source or destination for matching alignment.
> +       while ( (length !=0) && (((int) src & (sizeof(int)-1 ))!=0) )
> +               {
> +
> +                *((char*) dst++)=*((char*)src++);
> +               length--;
> +               }
> +
> +       //copy words
> +       while(length> (sizeof(int)-1) )
> +               {
> +               *((int*) dst)=*((int*)src);
> +               dst+=sizeof(int);
> +               src+=sizeof(int);
> +               length-=sizeof(int);
> +               }
> +
> +copyrest:
> +
> +       //now copy the rest byte-by-byte
> +       while(length !=0)
> +               {
> +               *((char*) dst++)=*((char*) src++);
> +               length--;
> +               }
> +
> +       return p;
>   }
>   EXPORT_SYMBOL(memcpy);
>   #endif
> 

-- 
Mihai Donțu
