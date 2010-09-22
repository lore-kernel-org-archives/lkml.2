Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0IVUzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:55:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45887 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0IVUzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:55:17 -0400
Message-ID: <4C9A6CFF.5040803@zytor.com>
Date: Wed, 22 Sep 2010 13:54:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <4C9A2AED.3050801@zytor.com> <20100922194331.GB28463@Krystal> <4C9A61AE.3080804@zytor.com> <20100922204101.GA3012@Krystal>
In-Reply-To: <20100922204101.GA3012@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 01:41 PM, Mathieu Desnoyers wrote:
>>
>> In the case of multiple instances of the same key you want the perfect
>> hash to point to the cluster of solutions -- a list.  Since this is by
>> simply be an array.
> 
> Yep, and sorting the section seems like a very natural way to create
> these arrays. So to summarize:
> 
> - We add a post-linking step to core image and module build in
>   modpost.c.
> - This step accesses exception tables, tracepoint and static jump
>   sections.
>   - Both tracepoint and static jump need to be sorted.
>   - For each of the 3 sections, a perfect hash is computed (creation
>     must have the property to always succeed). The perfect hash creation
>     should only take into account the first entry of duplicate keys.
>   - Each of these perfect hash would translate into C code that would
>     need to be compiled in a post-link phase.
>   - Then we can link the perfect hash objects with the rest of the code,
>     filling in one symbol per considered section (function pointer to
>     the perfect hash function) and setting function pointers in struct
>     module for modules.
> 
> I'm mostly writing this down as food for thoughts, since my own
> implementation time is currently focused on other things.
> 

For what it's worth, here is a working (verified and in use) perfect
hash generator written in Perl:

http://repo.or.cz/w/nasm.git/tree/HEAD:/perllib

Like most other perfect hash generators it needs a prehash: the prehash
should be parameterizable (seedable) and produce 2 ceil(log n) bits of
hash material and cannot have collisions.  The actual phash algorithm
compresses it down to a perfect hash.  The prehash is typically
generated via a pseudorandom algorithm: the particular implementation
pointed to uses one based on CRC64 because it's fast to compute but has
a finite probability of not existing; a universal prehash is guaranteed
to exist but is much more expensive.  In practice a very simple prehash
is usually sufficient, and one goes for speed.

For binary numbers being input, an even simpler prehash based on
multiplies or rotates is generally more than sufficient.

	-hpa
