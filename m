Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0FMVBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 17:01:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51764 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab0FMVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 17:01:41 -0400
Subject: Re: [PATCH] trace-cmd: prevent print_graph_duration buffer overflow
From: Chase Douglas <chase.douglas@canonical.com>
To: Valdis.Kletnieks@vt.edu
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <40245.1276462373@localhost>
References: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
	 <1276449108-21328-2-git-send-email-chase.douglas@canonical.com>
	 <40245.1276462373@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 17:01:34 -0400
Message-ID: <1276462894.2356.6.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 16:52 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 13 Jun 2010 13:11:48 EDT, Chase Douglas said:
> > Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
> > condition. We know the exact size of nsecs_str, so use it instead of
> > math that may overflow.
> 
> >  	/* Print nsecs (we don't want to exceed 7 numbers) */
> >  	if ((s->len - len) < 7) {
> > -		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
> > +		snprintf(nsecs_str, sizeof(nsecs_str), "%03lu", nsecs_rem);
> 
> We only get into this code after we've checked that the length is under 7
> characters.  How much overflow can happen as long as the sizeof(nsecs_str) is a
> sane size (like at least 8 chars)?  Probably a better bet would be doing the
> right thing and 'BUILD_BUG_ON(sizeof(nsecs_str) < 8);'?

nsecs_str is a local variable defined just above this block of code as:

	char nsecs_str[5];

I was hitting cases where s->len == 64 and len == 63, leading to the
size argument of snprintf being 7 on a 5 byte string. I didn't delve too
much into the reasoning for the if statement, but I think it's math is
not actually related to the size of nsecs_rem but to some other string
length.

-- Chase

