Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0JKQlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:41:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61019 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab0JKQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mNelRwLTrBghg3WZct0enaB8iOJ7qbwEbZJ2JN1VBezLj0azbTCh3JWdH4GVvx8Dil
         xz2hmTU+loL7QwO5nQArfO+pfjspukUcGKZMwrt7f7wg4ok/GmTbgtxZJLccStVZYv28
         PV7W7xqEtcNfsWZIR+YsjV1b0IIDjG9S+RiWQ=
Date: Mon, 11 Oct 2010 18:40:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ASoC: soc: snprintf() doesn't return negative
Message-ID: <20101011164038.GE5851@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20101011035416.GD5851@bicker> <20101011104009.GB9231@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011104009.GB9231@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 11:40:09AM +0100, Mark Brown wrote:
> On Mon, Oct 11, 2010 at 05:54:17AM +0200, Dan Carpenter wrote:
> > In user space snprintf() returns negative on errors but the kernel
> > version only returns positives.  It could potentially return sizes
> 
> I'm not going to apply this. snprintf() returns a signed type, checking
> that the return value is a reasonable thing to do here - at worst we're
> wasting a few cycles in code that's nowhere near a hot path, at best
> we're robust in the face of a decision to add error reporting to
> snprintf() so it's hard to see this change as an improvement.
> 

It's not a matter of cycles.  My check probably takes the exact same
number of cycles as your check.  The point is that checking for negative
doesn't make any sort of sense.  If we did return an error code then we
should check it immediately after return instead of adding it to previous
return code.

The snprintf() function is documented.  It can't be changed because that
would break a ton of code as explained below.

> > larger than the size of the buffer so we should check for that.
> 
> > -	if (ret >= 0)
> > -		ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> > +	if (ret > PAGE_SIZE)
> > +		ret = PAGE_SIZE;
> > +
> > +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> 
> The PAGE_SIZE part of the change has an issue too, the code immediately
> preceeding this is:
> 
> 	list_for_each_entry(codec, &codec_list, list)
> 		ret += snprintf(buf + ret, PAGE_SIZE - ret, "%s\n",
> 				codec->name);
> 
> so it's rather late to be worrying about PAGE_SIZE after the loop.
> 

There is no buffer overflow in these lines.  If "ret" *were* a negative
then there would be.  In that scenario we could end up copying data
before the start of the buffer because "buf - ret" could be before the
start of the buffer and we could end up copying after the end of the
buffer because "PAGE_SIZE - ret" would be larger than PAGE_SIZE.

If "PAGE_SIZE - ret" is a negative number then it triggers a
WARN_ON_ONCE() in vsnprintf().  It's not possible in this case however.
Really the original code works fine in practice because the information
we are printing out is less than PAGE_SIZE.

So my patch is effectively just a code cleanup.  If you don't apply it,
I'll probably sob into my pillow until it's wet but in the end it
doesn't matter much either way.  :P

regards,
dan carpenter

> Please also try to be a bit more thoughtful in your use of
> get_maintainers; try to have a look at why people have come up and
> consider if it's really sensible to include them.

