Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab0KKFQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 00:16:15 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:45526 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0KKFQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 00:16:13 -0500
Message-ID: <4CDB7C05.1090306@seas.upenn.edu>
Date: Thu, 11 Nov 2010 00:15:49 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se> <4CD724BC.8020702@seas.upenn.edu> <4CD80FCB.20903@euromail.se> <4CD82B28.4060706@seas.upenn.edu> <4CD84A81.3000208@euromail.se>
In-Reply-To: <4CD84A81.3000208@euromail.se>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-11_03:2010-11-11,2010-11-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1011100250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> For every (number of used slots, number of current contacts) pair, two
> consecutive arrays of values are generated. The first contains the matrix
> indices corresponding to a certain mapping from contacts to slots. The second
> contains the actual slot assignment.
> 
> To find the optimal matching, one simply scans through the appropriate index
> array, extracting the slot assignment corresponding to the minimum sum of matrix
> elements. This process is combinatorial and in general scales much worse than
> for instance the hungarian algorithm, but for small numbers, it can be
> implemented with very good speed.

It occurs to me that it might be a good idea to restate our goals and assumptions.

Goals:
- - better filtering: ghosts and drops
- - reduced cost:	compute/energy
- - accuracy of tracking
- - maximize functionality
- - durability: I want a routine that will last


Assumptions:
- - contacts in an untracked incoming frame are spatially sorted
- - consistent ordering of contacts from frame to frame is far more common than a
change in ordering
- - typically upsets in ordering are small
- - we can focus matching to reduce the number of comparisons needed
- - we can not trust matching of static positions
- - we should not assume and hard code a limit on the number of contacts
- - the density of contacts is limited.
- - perfection may not be possible and is not necessarily insteresting
- - new tracks are relatively rare and the rate of appearance (particularly in a
small region) is likely to be small
- - new tracks are likely to start slow, but may not

So from my perspective, the first stage should just be a quick sanity check on
the incoming frame.  Where the contacts are in the same order we should pay a
constant time for each contact, so O(n).

The code I sent should consume contacts from two lists.  As long as they match,
it just pops the first element from each.  As long as the two frames have the
same tracks, the worst case ordering will still result in at worst O(n^2), and
with a bit of spatial filtering, that would be an extremely unlikely scenario.


The start of a new track is a bit different.  If we assume 0 starting velocity,
we can use the same regional matching and get the same O(n) in the common case
and O(n^2) when we fail to find a match.  This n is just the unmatched contacts
from the current frame and the remaining tracked contacts and unmatched from the
previous.

When we are concerned about tracks that start with fast moving contacts, we have
a bit more to work out.  We could expand the search area for unmatched contacts
in the previous frame, but that requires dangerous assumptions and may result in
incorrect assignments.  Just imagine a flattened X where the upper corners are
the first frame and the lower corners are the second.  Ignoring motion, you
would find two vertical tracks, even though the two tracks are actually crossing
diagonals.  With velocity compensation, we need to consider all combinations of
vectors from the previous two frames and match against the current.  So that
step is O(n^3).

While that n^3 is undesirable, I asked around and have been told that it would
be a poor choice to ignore fast "swipes".  Moreover its again very unlikely that
we will have to deal with large n since we're only talking about the rate of new
tracks starting.  We can imagine a group of people deliberately trying to make
it behave poorly and synchronizing touching a screen in 60 places all at once.
However, it would be hard to do so with all those fingers moving fast.  And of
course with a bit of filtering, we can easily keep that to localized problems
and treat them as many smaller n^3 problems.  The maximum density can't really
be all that high, and I would think the maximum for moving tracks would be quite
a bit lower.

The last tidbit I included is drop filtering.  When a track is lost, and then
new contacts come in later, we can go back to the list of those lost tracks and
try to find a match.  With assumptions for how far back we're willing to look,
we're still not talking about a lot of comparisons, and we only need to consider
two lists not three, so this step is still only going to be quadratic.  With
increasing uncertainty over time I thought it would be good to increase the
target ranges for aging lost tracks.  My approach there is purely intuitive and
I'd love any better ideas.


So that's why I selected the approach and data structures I used.  Now if you
can tell me the studio 17 is going to be the only device that will ever run
these routines that has more than 4 contacts and is not tracked, then sure,
screw it.  I have no reason to believe that is a good assumption.

Even if we do want to limit the code to 4 contacts, we still need some motion
estimation, particularly for the lower frame rate devices.


Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJM23v/AAoJEPILXytRLnK2nOEQAKKVrxP5ovGwm8hGOK5moYEn
XLw+jjHKd0zJIRuPTeKO8pWRY3HfN6OfqUEu38Agfyx0gbPv7QfXazCi8zY+Nihh
nfoQ2fsWFKYqGo+tKKgmijTi/aQ0VLBq6t1IejFbdslyAWLA7c3WDPAS+eiiGsfY
L9kFEvzFbaYrYZA7YmVHi5xp4nuH047mBsC9BxiKvqywPl86ZXPec4tq/yKkWjLu
MCqVW8mw7xJAqd+rie0VRCqYCXPJuciqkU6DFOMkTL6suxymBXPKtNT0kt3Sebcs
dwaCHLzH0AFhdPkb/NUJKJvZe5Qtc4p/Le9uKp0/wDvdnPaX7c8ETsC3TKWP2sQl
dy25litr2tXlbPI8O2q3qJeofqHGD5UyFvy6qgXpSDi+2q/rkbjYtAyWZW41xN+1
YlNHRAWppsrsOTeps7Zq2BkGeNQIgCOh0ErcSpldjYUZUgM0hRmJcGSsZmPS7aDR
XE4vBTpCDjHywN1ejG1rugWelz9Ck82redNNNfHk2IQf5Idf5oZCMvAeqESNGKg/
KJ+06+C4uckEh+PvKiBnekJNfDkBGAnt42XYfhkRhTMQP+BU5IhhWGgY75RMypFT
F5YyMwdKw0vzlC206LwiWim80tDbL4LNhOBOTkErCrB2/vP/YedGTGeItoUbHx3Y
SQ1QZhzUyZFYpWpo5uZB
=tZOo
-----END PGP SIGNATURE-----
