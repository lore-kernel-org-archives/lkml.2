Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1ILSaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1ILSac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:30:32 -0400
Message-ID: <4E6E4EBB.9010608@redhat.com>
Date: Mon, 12 Sep 2011 14:26:03 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Sandy Harris <sandyinchina@gmail.com>, Steve Grubb <sgrubb@redhat.com>,
        Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315464117.11199.51.camel@vespa.frost.loc> <20110908125234.GD13657@hmsreliant.think-freely.org> <201109080911.12921.sgrubb@redhat.com> <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com> <118704.1315706746@turing-police.cc.vt.edu>            <4E6E0F43.6070307@redhat.com> <11721.1315846699@turing-police.cc.vt.edu>
In-Reply-To: <11721.1315846699@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 12 Sep 2011 09:55:15 EDT, Jarod Wilson said:
>
>> Well, previously, we were looking at simply improving random entropy
>> contributions, but quoting Matt Mackall from here:
>>
>> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05799.html
>>
>> 'I recommend you do some Google searches for "ssl timing attack" and
>> "aes timing attack" to get a feel for the kind of seemingly impossible
>> things that can be done and thereby recalibrate your scale of the
>> impossible.'
>
> If you're referring to Dan Bernstein's 2005 paper on AES timing attacks
> (http://cr.yp.to/antiforgery/cachetiming-20050414.pdf), note that it took
> him on the order of 2*25 packets per byte of AES key - targeting a
> dummy server intentionally designed to minimize noise.  Although he
> correctly notes:
>
>       Of course, I wrote this server to minimize the amount of noise in the timings
>    available to the client. However, adding noise does not stop the attack: the client
>    simply averages over a larger number of samples, as in [7]. In particular, reducing
>    the precision of the server's timestamps, or eliminating them from the server's
>    responses, does not stop the attack: the client simply uses round-trip timings
>    based on its local clock, and compensates for the increased noise by averaging
>    over a larger number of samples.
>
> one has to remember that he's measuring average differences in processing
> time on the order of single-digits of cycles - if any *real* processing was happening
> it would only take a few cache line misses or an 'if' statement branching the
> other way to almost totally drown out the AES computation.  (Personally,
> I'm amazed that FreeBSD 4.8's kernel is predictable enough to do these
> measurements - probably helps a *lot* that the server was otherwise idle -
> if somebody else was getting a timeslice in between it would totally swamp
> the numbers).
>
> Dan's reference [7] mentions specifically that RSA blinding (first implemented
> by default all the way back in OpenSSL 0.9.7b) defeats that paper's timing
> attack.
>
> If anything, those attacks are the best proof possible that the suggested
> "fix" for /dev/urandom is a fool's errand - why would anybody bother trying to
> figure out what the "next" data out of /dev/urandom is, when they can simply
> wait for a few milliseconds and extract it out of whatever program read it? :)

I'm not referring to anything in particular, I'm mostly referring to the 
irony that one approach that was shot down was because, while not 
exactly practical, its theoretically not impossible to figure out clock 
sample entropy contributions, which might weaken the strength of the 
entropy pool. Your argument is more or less directly opposed to the 
reasoning the clock entropy patches were deemed unacceptable. :)

Something to keep in mind: the whole impetus behind all this is 
*government* crypto certification requirements. They're paranoid. And 
something impractical at the individual level is less so at the 
"determined, and willing to spend buckets of cash on resources, hostile 
foreign government level. At least in the minds of some governments.

Note also: I don't necessarily share said governments' sentiments, I'm 
just tasked with trying to satisfy the requirements, and this was looked 
at as a potential minimally-invasive solution. I still think paranoid 
government-types would be fine with applications falling down if urandom 
blocked, because that should *only* happen if the system is being 
abused, but I understand the objections, so that idea is off the table.

I'm likely going to look into Sasha's suggestion to do something via 
CUSE next, followed by taking a long hard look at what's involved in 
rewriting the entropy estimation logic such that clock-based entropy 
would be acceptable.

-- 
Jarod Wilson
jarod@redhat.com


