Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1IICVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:21:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60210 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab1IICVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <201109080911.12921.sgrubb@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	<1315464117.11199.51.camel@vespa.frost.loc>
	<20110908125234.GD13657@hmsreliant.think-freely.org>
	<201109080911.12921.sgrubb@redhat.com>
Date: Fri, 9 Sep 2011 10:21:13 +0800
Message-ID: <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Sandy Harris <sandyinchina@gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 9:11 PM, Steve Grubb <sgrubb@redhat.com> wrote:

> The system being low on entropy is another problem that should be addressed. For our
> purposes, we cannot say take it from TPM or RDRND or any plugin board. We have to have
> the mathematical analysis that goes with it, we need to know where the entropy comes
> from, and a worst case entropy estimation.

Much of that is in the driver code's comments or previous email
threads. For example,
this thread cover many of the issues:
http://yarchive.net/comp/linux/dev_random.html
There are plenty of others as well.

> It has to be documented in detail.

Yes. But apart from code comments, what documentation
are we talking about? Googling for /dev/random on tldp.org
turns up nothing that treats this in any detail.


> The only
> way we can be certain is if its based on system events. Linux systems are constantly
> low on entropy and this really needs addressing. But that is a separate issue. For
> real world use, I'd recommend everyone use a TPM chip + rngd and you'll never be short
> on random numbers.

Yes. Here's something I wrote on the Debian Freedombox list:

| No problem on a typical Linux desktop; it does not
| do much crypto and /dev/random gets input from
| keyboard & mouse movement, disk delays, etc.
| However, it might be a major problem for a plug
| server that does more crypto, runs headless, and
| use solid state storage.

| Some plug computers may have a hardware RNG,
| which is the best solution, but we cannot count on
| that in the general case.

| Where the plug has a sound card equivalent, and
| it isn't used for sound, there is a good solution
| using circuit noise in the card as the basis for
| a hardware RNG.
| http://www.av8n.com/turbid/paper/turbid.htm

| A good academic paper on the problem is:
| https://db.usenix.org/publications/library/proceedings/sec98/gutmann.html

| However, his software does not turn up in
| the Ubuntu repository. Is it in Debian?
| Could it be?

| Ubuntu, and I assume Debian, does have
| Havege, another researcher's solution
| to the same problem.
| http://www.irisa.fr/caps/projects/hipsor/

Some of that sort of discussion should be in the documentation.
I'm not sure how much currently is.

> But in the case where we are certifying the OS, we need the
> mathematical argument to prove that unaided, things are correct.

No, we cannot "prove that unaided, things are correct" if
by "correct" you mean urandom output is safe against all
conceivable attacks and by "unaided" you mean without
new entropy inputs. It is a PRNG, so without reseeding it
must be breakable in theory; that comes with the territory.

That need not be a problem, though. We cannot /prove/
that any of the ciphers or hashes in widespread use are
correct either. In fact, we can prove the opposite; they
are all provably breakable by an opponent with enough
resources, for extremely large values of enough.

Consider a block cipher like AES: there are three known
attacks that must break it in theory -- brute force search
for the key, or reduce the cipher to a set of equations
then feed in some known plaintext/ciphertext pairs and
solve for the key, or just collect enough known pairs to
build a codebook that breaks the cipher. We know the
brute force and codebook attacks are astronomically
expensive, and there are good arguments that algebra
is as well, but they all work in theory. Despite that, we
can use AES with reasonable confidence and with
certifications from various government bodies.

There are similar arguments for confidence in urandom.
The simplest are the size of the state relative to the
outputs and the XOR that reduces 160 bits of SHA-1
output to 80 of generator output. More detailed discussion is
in the first thread I cited above.

Barring a complete failure of SHA-1, an enemy who wants to
infer the state from outputs needs astronomically large amounts
of both data and effort.
