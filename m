Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2AZUfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:35:46 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:29414 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2AZUfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:35:44 -0500
X-Authority-Analysis: v=2.0 cv=ad3jbGUt c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=seg9fo12g4kA:10 a=LNmbJxpDd3oA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=Ap5BOXVSaaG6XEptU8YA:9 a=ac9XEOwaVzYJz9280gUA:7 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F21B91E.90106@ubuntu.com>
Date: Thu, 26 Jan 2012 15:35:42 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Maxim Patlasov <maxim.patlasov@gmail.com>, joe@perches.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com> <4EFD012D.7040602@cfl.rr.com> <20120126190114.GG1891@redhat.com>
In-Reply-To: <20120126190114.GG1891@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/26/2012 2:01 PM, Vivek Goyal wrote:
> I thought update will always happen with mutex lock held. That's
> what sequence counter expects so that two updaters don't race. Just
> that while updating under mutex lock, we still need to use sequence
> counter mecahinsm to update values so that any readers out there
> not holding mutex don't get confused.

Yes, but holding the mutex while writing does no good for the reader.
 When the writer doesn't use the seqcounter, then the reader that is
using it is not actually protected.

> Right now readers can afford not to take lock. Introducing mutex on
> read side with just add to the cost. Especially IO submission path
> where we map IO to a partitiona and we wouldn't want to take
> mutexes there?

Yes, it does look like readers can't afford that overhead.

> Are you still pursuing this pathset? Sounds like a useful
> functionality to have.

Yes, but I hadn't yet heard back about my question about this being a
broader issue that is already a bug in the kernel because things like
loop and md already change nr_sects ( on the whole disk partition )
without any protection.

Maybe what we need is a read/write lock on struct genhd, then all
readers need to acquire the read lock, which should only slow them
down if they collide with a writer.

Another idea that I had but have not yet checked to see if it is
actually feasible is to copy the struct genhd, change the size of the
copy, and replace the existing one since updating the pointer will be
atomic.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPIbkeAAoJEJrBOlT6nu75Bx8IAKgTgA4czpng+JaQkja7n8j9
8B+e+9Asnyp/ND3qkxdUHwmRwJxmC+fJV9PVT84neoBHugN63rX3afc4KGJp5elg
k21kziCy46cbIOOeYQDkTZnkHoqHL3dd1sJhO6tv7bDjtRKW0PVY855sKQKW8cNk
zjX0WA+iaePs0+Yhd921MwKisRyWtpUr5Sm3Ib0h4kTjRKL7Nyk6cHNH516HpuD2
mXTDCbK5eRhljiadd7igCbbUQNVyFNHm3JGcgLLw35dnarzobZFDlrN1ybXoPExC
31FhDG2Vbo5kLlUNibIsuuf9DoYzBilMTyE/aHN1EtjkTk8bKMg3lZoUi1sVV7c=
=TMsc
-----END PGP SIGNATURE-----
