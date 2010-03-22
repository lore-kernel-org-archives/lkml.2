Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0CVQyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:54:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39664 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab0CVQym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IacqvUT0fuIDya0hnF/eNQvXR9hSoesajyyun1nzFQs9DYMy7DWt+dF2bRgB1ortnX
         7TEZakNVVkeQ7GFfjludZt08JUFU8kNSz0FBPqt6xYYZHxrz41L9MYuLHU6+CBqNHAWj
         EXaMUO+PndZeTDxQK/sCsnEWtGIJwxFlxDLbw=
Date: Mon, 22 Mar 2010 19:54:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Joe Perches <joe@perches.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Srinivasa Deevi <srinivasa.deevi@conexant.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] cx231xx: card->driver "Conexant cx231xx Audio" too
	long
Message-ID: <20100322165430.GU21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>, Joe Perches <joe@perches.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100319114957.GQ5331@bicker> <s5hr5ncxvm9.wl%tiwai@suse.de> <20100322153909.GC23411@bicker> <1269272627.22616.35.camel@Joe-Laptop.home> <s5h39zsxryw.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h39zsxryw.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 05:04:55PM +0100, Takashi Iwai wrote:
> At Mon, 22 Mar 2010 08:43:47 -0700,
> Joe Perches wrote:
> > 
> > On Mon, 2010-03-22 at 18:39 +0300, Dan Carpenter wrote:
> > > card->driver is 15 characters and a NULL, the original code could 
> > > cause a buffer overflow.
> > 
> > > In version 2, I used a better name that Takashi Iwai suggested.
> > 
> > Perhaps it's better to use strncpy as well.
> 
> strlcpy() would be safer :)
> 
> But, in such a case, we want rather that the error is notified at
> build time.
> 
> Maybe a macro like below would be helpful to catch such bugs?
> 
> #define COPY_STRING(buf, src)						\
> 	do {								\
> 		if (__builtin_constant_p(src))				\
> 			BUILD_BUG_ON(strlen(src) >= sizeof(buf));	\
> 		strcpy(buf, src);					\
> 	} while (0)
> 
> and used like:
> 
> struct foo {
> 	char foo[5];
> } x;
> 
> COPY_STRING(x.foo, "OK"); // OK
> COPY_STRING(x.foo, "1234567890"); // NG
> 

I can do the same thing with Smatch.  The smatch check can also find 
bugs like this:

	buf = kmalloc(10, GFP_KERNEL);
	strcpy(buf, "1234567890"); 

I used smatch to find this bug and 5 others on my allmodconfig w/ staging.
I also found 19 other places that use strcpy() to copy from a large buffer
into a smaller buffer.

Your idea is nice, but I think anyone who deliberately uses the new
macro is not going to have the bug in the first place.  ;)

regards,
dan carpenter

> 
> Takashi
