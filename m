Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1GTN3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:29:42 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:18472
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab1GTN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:29:41 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432N98dK4015Lzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOMW51-02-CVA-02
X-M-MSG: 
Date: Wed, 20 Jul 2011 15:29:25 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry
Message-ID: <20110720132925.GB21948@amd.com>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110720103813.GL15108@amd.com>
 <20110720111156.GA12349@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110720111156.GA12349@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 07:11:56AM -0400, Neil Horman wrote:
> On Wed, Jul 20, 2011 at 12:38:13PM +0200, Roedel, Joerg wrote:

> > But it is not that easy. The hash_fn works on the dev_addr, this means
> > to search all entries which might match you need to scan multiple
> > hash-buckets potentially.
> > In fact, you need to scan
> > 
> > 	hash_fn(estart) <= idx <= hash_fn(eend)
> > 
> Ah, good point.  Its actually a bit more difficult that what you describe I
> think.  Given a ref->dev_addr, this check needs to find the entry in any bucket
> for a matching device that has an entry->dev_addr less than ref->dev_addr, where
> the former has a larger size than the latter.  And since we don't know the true
> size of the entry we are looking for, we could have crossed the HASH_FN_SHIFT
> many times over to get to the ref->dev addr that was passed in.  It almost
> sounds like the hash table for this needs to be accessible by device rather than
> by address.

You are right. We need to scan

	0 <= idx <= hash_fn(rstart)

Probably we can fix that with a better hash-function. Any ideas? Using
the device is not an option because then all entries would end up in
only a few buckets. This will impact scanning performance too much.

For now, the partial syncs seem to happen rarely enough so that we can
make it a slow-path. It is probably the best to do the exact scan first
and do the full scan only if exact-scan failed (until we come up with a
better solution).


> > to be sure. The patch above also lifts up the check_unmap which is not
> > desired.
> Hm, you're right, I suppose we need to add an exact map option to the passed in
> ref structure or some such, I'll rework this

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

