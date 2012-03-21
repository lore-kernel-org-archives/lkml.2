Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2CUDLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 23:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab2CUDLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 23:11:36 -0400
Date: Tue, 20 Mar 2012 23:11:25 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: Mandeep Singh Baines <msb@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Elly Jones <ellyjones@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: remake of the verity target
In-Reply-To: <Pine.LNX.4.64.1203202045150.23255@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1203202233250.6371@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com> <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com> <20120320154159.GD27051@google.com>
 <Pine.LNX.4.64.1203202045150.23255@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2012, Mikulas Patocka wrote:

> > Changes:
> > 
> > * Salt is hashed before the block (it used to be hased after). The reason 
> > is that if random salt is hashed before the block, it makes the process 
> > resilient to hash function collisions - so you can safely use md5, even if 
> > there's a collision attach for it.
> 
> I am not aware of any additional benefit to prepending the salt versus
> appending. Could you please provide such a reference.
> 
> I would like to avoid breaking backward compatibility unless there is
> a real benefit.
> 
> Regards,
> Mandeep
> 

This is some deeper explanation why I do it this way. The reason is to 
protect agains collision attacks (such as a known attack on MD5 or 
possible future attacks against other hash functions).

"Preimage attack" means that you are given a hash value and you create a 
message that hashes to that hash value. There is no known preimage attack 
for currently used hash functions.

"Collision attack" means that you are able to create two messages that 
hash into the same hash value. There is currently collision attack known 
for MD5.


Suppose that I publish some software, calculate MD5 digest of it and sign 
that digest. This is safe (despite the existing collision attack on MD5) 
beacuse there is no preimage attack --- no one is able to create another 
file with the same MD5 hash.

However, it is still possible to break security with collision attack, but 
the attacker must be able to submit some of his data into the software 
signed with MD5.


Suppose for example that software developer publishes "real_program" and 
signs it with MD5. The attacker inserts some security backdoor into the 
program and gets "insecure_program". The attacker takes two MD5 states --- 
the state as it was after hashing "real_program" and the state as it was 
after hashing "insecure_program" --- and with collision attack, he is able 
to create two messages "m1" and "m2" such that they result in MD5 
collision.

The result is that
MD5("real_program"+"m1") and MD5("insecure_program"+"m2") hash to the same 
value.

Now, to make the attack successful, the attacker must trick the software 
developer somehow into inserting "m1" into his program.

It is not trivial, but possible to trick the software developer into 
inserting attacker-controlled data into the program. For example, the 
attacker can send him a file containing the string "m1" and claim that it 
is Chinese localization of the program --- if the software developer has 
no knowledge of Chinese writing system, he can't diferentiate a real 
Chinese text from a string of random characters --- so he inserts the file 
containing "m1" into his program and publishes it.

Now the attack is finished, the software developer published and signed 
"real_program"+"m1" and there exists another file "insecure_program"+"m2" 
that hashes into the same MD5 value. So the attacker can misrepresent 
"insecure_program"+"m2" as being real.


You can protect from this situation either by using a hash function 
without collision attack or by prepending some random data before the 
program to be hashed. If the developer signs "random_data"+"real_program" 
with MD5 in the above example, there is no way how the attacker can create 
a collision --- the attacker can still create "m1" and "m2" and trick the 
developer into including "m1" in the program --- but the developer uses 
different "random_data" next time he publishes a next version of the 
software, so there will be no MD5 collision.


This is a reason why I changed dm-verity hashing system. The salt is 
random-generated when creating the hashes. When we hash a data block, we 
prepend the salt to the data. Consequently, the attacker can't exploit the 
collision attack as described above. If we append the hash (as it used to 
be before), it would be possible to exploit the collision attack.

Mikulas
