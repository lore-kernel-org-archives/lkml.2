Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2HTIVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:21:23 -0400
Received: from asav3.lyse.net ([81.167.37.131]:45135 "EHLO asav3.lyse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2HTIVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:21:19 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2012 04:21:18 EDT
Message-ID: <5031EB9B.5010400@hesbynett.no>
Date: Mon, 20 Aug 2012 09:47:39 +0200
From: David Brown <david.brown@hesbynett.no>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: stan@hardwarefreak.com, Michael Tokarev <mjt@tls.msk.ru>,
        Miquel van Smoorenburg <mikevs@xs4all.net>,
        Linux RAID <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no> <50317804.9010701@hardwarefreak.com> <20120820100134.22b2b056@notabene.brown>
In-Reply-To: <20120820100134.22b2b056@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/2012 02:01, NeilBrown wrote:
> On Sun, 19 Aug 2012 18:34:28 -0500 Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
>
>
> Since we are trying to set the record straight....
>
>> md/RAID6 must read all devices in a RMW cycle.
>
> md/RAID6 must read all data devices (i.e. not parity devices) which it is not
> going to write to, in an RWM cycle (which the code actually calls RCW -
> reconstruct-write).
>
>>
>> md/RAID5 takes a shortcut for single block writes, and must only read
>> one drive for the RMW cycle.
>
> md/RAID5 uses an alternate mechanism when the number of data blocks that need
> to be written is less than half the number of data blocks in a stripe.  In
> this alternate mechansim (which the code calls RMW - read-modify-write),
> md/RAID5 reads all the blocks that it is about to write to, plus the parity
> block.  It then computes the new parity and writes it out along with the new
> data.
>

I've learned something here too - I thought this mechanism was only used 
for a single block write.  Thanks for the correction, Neil.

If you (or anyone else) are ever interested in implementing the same 
thing in raid6, the maths is not actually too bad (now that I've thought 
about it).  (I understand the theory here, but I'm afraid I don't have 
the experience with kernel programming to do the implementation.)

To change a few data blocks, you need to read in the old data blocks 
(Da, Db, etc.) and the old parities (P, Q).

Calculate the xor differences Xa = Da + D'a, Xb = Db + D'b, etc.

The new P parity is P' = P + Xa + Xb +...

The new Q parity is Q' = P + (g^a).Xa + (g^b).Xb + ...
The power series there is just the normal raid6 Q-parity calculation 
with most entries set to 0, and the Xa, Xb, etc. in the appropriate spots.

If the raid6 Q-parity function already has short-cuts for handling zero 
entries (I haven't looked, but the mechanism might be in place to 
slightly speed up dual-failure recovery), then all the blocks are in place.


