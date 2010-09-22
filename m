Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0IVQNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:13:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab0IVQNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:13:36 -0400
Message-ID: <4C9A2AED.3050801@zytor.com>
Date: Wed, 22 Sep 2010 09:12:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: jbaron@redhat.com, rostedt@goodmis.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1285150102-5506-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 03:08 AM, Andi Kleen wrote:
>
> I believe it's also much cleaner than before.
>
> I did some performance tests comparing the hash implementation
> with the binary search. This was with a moderate config x86-64
> kernel with 68 modules loaded and about 480 trace points active
> in several modules and 1340 dynamic debug statements.
>

Now, the ideal data structure for this stuff is something called a 
minimal perfect hash.  This is something that would have to be generated 
(for each module and for the monolithic kernel) at compile time -- 
presumably in modpost -- because the static generation of them is fairly 
complex.

That would provide extremely simple handling in the kernel (just do some 
shifts and a table lookup and you have your answer) and if combined with 
an AVL or red-black tree holding the module addresses it would give 
extremely fast address-to-metadata lookup, not just for this but also 
for things like exception handling.

I have used MPH's in other projects and pitched them to Linus at one 
point for exception handling.  What is clear, though, is that we should 
do the same thing for exceptions, trace points, and any other similar 
things that depend on exact PC.

	-hpa
