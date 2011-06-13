Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1FMUzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:55:18 -0400
Received: from mta11.charter.net ([216.33.127.80]:39207 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1FMUzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:55:15 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=lE-93N_JSvIA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=9XBe0NCsY1WFNFANlCAA:9
 a=TcBE-hqLoL9zUOFduFcA:7 a=wPNLvfGTeEIA:10 a=Hb4wLTPsQwJL0Xvf:21
 a=fKCo1N-dxqBHNrlT:21 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF67933.9080707@cuw.edu>
Date: Mon, 13 Jun 2011 15:55:15 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: if (ret) return ret; return ret; semantic
 patch
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk> <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu> <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 01:38 PM, Julia Lawall wrote:
> How about:
>
> @@
> identifier f;
> expression ret;
> identifier x;
> @@
>
> (
> - if (likely(x)) return ret;
> |
> - if (\(IS_ERR\|IS_ZERO\|is_ordinal_table\)(x)) return ret;
> |
>    if (<+...f(...)...+>) return ret;
> |
> - if (...) return ret;
> )
> return ret;
>
>    
just curious... i see you usually just write "return ret;" here when 
posting. I've assumed that's because it will 1) work and 2) is close enough.

You'll notice I've been doing:
-return ret;
+return ret;
because it seems to help coccinelle realize that it can get rid of extra 
line feeds - does this make sense - or should i just be doing a "return 
ret"?
> I have put the likely case separate from the other function calls to
> benefit from the isomorphism.  I have restricted the argument to these
> functions to be an identifier so that it won't have any side effects.  It
> doesn't have to be the same as ret though.  The third line keeps all other
> ifs that contain function calls.  The fourth line gets rid of everything
> else.
>
> You could see if this finds all of the cases of your proposed rule and if
> it at least doesn't find anything else that you don't want it to find.
>
>    
I'll try it out this afternoon/evening hopefully.
> julia
>
>    

There are two other issues with the patch that I've noticed. I'll be 
teaching myself more on coccinelle to figure these out. Unless someone 
else wants to jump in :) So far I've read or skimmed a number of paper's 
that have been written on Coccinelle... I find it all very interesting :)

1) sometimes you see this type of code - which i've chosen to ignore for 
now:
if ((ret=XXXXX) < 0)
     return ret;
return ret;

which could just be simplified to:
return XXXXX;

for an example see the function load_firmware in 
sound/pci/echoaudio/echoaudio_dsp.c

2) after the semantic patch has removed an "if (...)return ret;" Quite 
often, but not always, we end up with this:
ret=...;
return ret;

which of course could just become
return ...;


So as you can see the problems are quite similar, but a little different.

Greg

