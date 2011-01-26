Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1AZSY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:24:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39942 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1AZSYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vY2bRlZi7WeRfEAtIB6PI6Yh1zFamyPAhIOfMc8jqHgweppcMV2BXKJp9KwFrcR9Xv
         E3c7NZG8/VJDh1RJ74tI9k9sulM39wOelt8sIqMjzX7M4gRe1txyMMWLn84wxRqXC7H0
         68d5sSPQ039pxv/Jfa+dGseRtsdVtWjIYmiKM=
Date: Wed, 26 Jan 2011 10:24:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126182415.GB29268@core.coreip.homeip.net>
References: <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D4004F9.6090200@redhat.com>
 <4D401CC5.4020000@redhat.com>
 <4D402D35.4090206@redhat.com>
 <20110126165132.GC29163@core.coreip.homeip.net>
 <4D4059E5.7050300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4059E5.7050300@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:29:09PM -0200, Mauro Carvalho Chehab wrote:
> Em 26-01-2011 14:51, Dmitry Torokhov escreveu:
> > On Wed, Jan 26, 2011 at 12:18:29PM -0200, Mauro Carvalho Chehab wrote:
> >> diff --git a/input.c b/input.c
> >> index d57a31e..a9bd5e8 100644
> >> --- a/input.c
> >> +++ b/input.c
> >> @@ -101,8 +101,8 @@ int device_open(int nr, int verbose)
> >>  		close(fd);
> >>  		return -1;
> >>  	}
> >> -	if (EV_VERSION != version) {
> >> -		fprintf(stderr, "protocol version mismatch (expected %d, got %d)\n",
> >> +	if (EV_VERSION > version) {
> >> +		fprintf(stderr, "protocol version mismatch (expected >= %d, got %d)\n",
> >>  			EV_VERSION, version);
> > 
> > Please do not do this. It causes check to "float" depending on the
> > version of kernel headers it was compiled against.
> > 
> > The check should be against concrete version (0x10000 in this case).
> 
> The idea here is to not prevent it to load if version is 0x10001.
> This is actually the only change that it is really needed (after applying
> your KEY_RESERVED patch to 2.6.37) for the tool to work. Reverting it causes
> the error:

You did not understand. When comparing against EV_VERSION, if you
compile on 2.6.32 you are comparing with 0x10000. If you are compiling
on 2.6.37 you are comparing with 0x10001 as EV_VERSION value changes
(not the value returned by EVIOCGVERSION, the value of the _define_
itself).

The proper check is:

#define EVDEV_MIN_VERSION 0x10000
	if (version < EVDEV_MIN_VERSION) {
		fprintf(stderr,
			"protocol version mismatch (need at least %d, got %d)\n",
			EVDEV_MIN_VERSION, version);
		...
	}

-- 
Dmitry
