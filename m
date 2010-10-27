Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0J0Qr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0J0QrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:47:25 -0400
Message-ID: <4CC85771.2080307@redhat.com>
Date: Wed, 27 Oct 2010 14:46:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com>	<4CC84597.4000204@gmail.com>	<4CC84846.6020304@redhat.com> <AANLkTim=RfR3Dq0w+ACYjhGTHCSgapdf35wGW8QoZ38n@mail.gmail.com>
In-Reply-To: <AANLkTim=RfR3Dq0w+ACYjhGTHCSgapdf35wGW8QoZ38n@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-10-2010 13:48, Devin Heitmueller escreveu:
> On Wed, Oct 27, 2010 at 11:41 AM, Mauro Carvalho Chehab
> 
> Have you looked at the code for how the Conexant guys got the xc5000
> firmware load to work (which uses 64 bytes at a time).  I suspect what
> *really* needs to happen is that needs to be made generic so that the
> stop bit is properly set (which would allow a single i2c transaction
> to span across multiple USB control messages).
> 
> Note that the xc5000 hack is actually two changes merged together -
> one uses a GPIO mode in certain cases to handle clock stretching
> properly (which probably has to stay there for now), and the other
> allows for larger i2c transactions.  I am referring to the latter
> change.
> 
> If we fix the cx231xx i2c master, then we can go back to the original
> 18271 config, which avoids the risk of regression for other devices.

The original code is broken, as it doesn't properly honour a max size of 8.
Even if we do some optimization at cx231xx, we still need to fix the tda18271
code, as it is trying to use more than 8 bytes on some writes.

Also, as you noticed, the way cx231xx sends large firmwares to xc5000 is a hack:
it requires to identify that the I2C device is a xc5000 and do an special
treatment for it.

We may actually move all those small_i2c logic to the bridge drivers, adding
those hacks inside the I2C adapter part, but this means that they'll need to 
have some complex-logic that are dependent on what device is connected to it,
damaging the benefits that the I2C bus abstraction brings.

Instead of polluting bridge drivers with I2C-device specific code, the proper
way seems to use parameters to adjust the maximum size, eventually flagging
the broken messages in a way that the I2C adapter won't sent a stop transaction
in the middle of a larger initialization like this one.

Cheers,
Mauro
