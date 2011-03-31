Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab1CaRQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:16:08 -0400
Received: from ist.d-labs.de ([213.239.218.44]:38547 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758719Ab1CaRQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:16:06 -0400
Date: Thu, 31 Mar 2011 19:15:38 +0200
From: Florian Mickler <florian@mickler.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG] NULL pointer dereference in dev_get_drvdata
Message-ID: <20110331191538.27afef9a@schatten.dmk.lab>
In-Reply-To: <4D94A0C1.1060608@gmail.com>
References: <1301448497.14261.319.camel@gandalf.stny.rr.com>
	<4D93508D.30701@gmail.com>
	<20110331111659.0c77abbe@schatten.dmk.lab>
	<4D94A0C1.1060608@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 08:41:53 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> >
> two drivers calling the same function(sounds bad!) this would be a race 
> condition right?

No. A race is about data. While many races involve the same function
beeing called multiple times in parallel, it is not necessary. It may
well be two seperate functions accessing the same data. 

Also you can of course have two functions doing the same thing to
different data. Just look at dev_get_drvdata... 

void *dev_get_drvdata(const struct device *dev)
{
        if (dev && dev->p)
                return dev->p->driver_data;
        return NULL;
}


it just returns a memory address relativ to the *dev pointer given to
it.  So if you call it multiple times in parallel with different *dev
pointers, nothing happens. 

In fact, dev_get_drvdata is read only, so it alone can never cause any
race. (Except in some obscure on-stack dma setups which are broken,
uncommen and avoided)

For dev_get_drvdata to be part of a race, you would have (for example)
something setting dev->p to NULL in parallel. 

That way, if that something gets to execute between the 

	if (dev && dev->p) 

line and the 
		return dev->p->driver_data;

then, that would be bad, because dev_get_drvdata would have already
decided that that if is true.... 

 
> As for this message I will keep my eye out for anything in this area and 
> report it to you guys.

But please if you put up fotos, try to have a pixel:character quota of
more then 3 ... and also remember, the stacktrace is
almost always the important part of the warning.

Regards,
Flo
