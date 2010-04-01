Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0DAFNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:13:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38045 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0DAFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RNlbG4Twz7tGLAICX6vVaxcqOg9bKjZIW71TKUe+urRjZm0LLiIZ8BCOcA+jprVF2q
         ELQEpl6aFpQOUmwadiTw0lK7VyRsicZoCMDzZdDMq0b0dqsCAmqwj0Tc8KoJgFRTg11/
         3ehdPpDGIB23Sze76T7NSTwbJH742JF+4bRO0=
Date: Thu, 1 Apr 2010 08:13:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/7] ring-buffer: Add lost event count to end of sub
	buffer
Message-ID: <20100401061343.GA5207@nowhere>
References: <20100401031735.683626160@goodmis.org> <20100401031820.590115556@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401031820.590115556@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:17:42PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Currently, binary readers of the ring buffer only know where events were
> lost, but not how many events were lost at that location.
> This information is available, but it would require adding another
> field to the sub buffer header to include it.
> 
> But when a event can not fit at the end of a sub buffer, it is written
> to the next sub buffer. This means there is a good chance that the
> buffer may have room to hold this counter. If it does, write
> the counter at the end of the sub buffer and set another flag
> in the data size field that states that this information exists.


Since you can not ensure you have a room for that,
is there no way to delay the update of cpu_buffer->last_overrun
until you find a large enough end of page for that?

I mean, you do this in rb_get_page():

       if (overwrite != cpu_buffer->last_overrun) {
               cpu_buffer->lost_events = overwrite - cpu_buffer->last_overrun;
               cpu_buffer->last_overrun = overwrite;
       }

If you don't have enough room to put lost_events in the end of
the buffer, you could keep as is cpu_buffer->last_overrun,
so the next time you swap the reader page, the new delta
will be added to the previous that you couldn't transmit.

That way you ensure the user always know when you lose events.

