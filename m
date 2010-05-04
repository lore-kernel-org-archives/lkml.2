Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab0EDM4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:56:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44110 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0EDM4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Gmpy4cPuyQxejIdIaCS3cP2C0FRP6m2+0Ur3bIkSAlf7dpjqAKFoFgrg5XpMdi6VuL
         2pDjPi4XdIfZrnwF2vmSztP2RNhWT0MkHDZxmllkx1rUNYlcij6ArMsppafFXnfjs/Fs
         RcwR4VrbjeuJBlRAEnCh2v4cLseBF93sjJ2X0=
Date: Tue, 4 May 2010 21:56:45 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de
Cc: yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/12] KVM, x86, ppc, asm-generic: moving dirty bitmaps
 to user space
Message-Id: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry for sending from my personal account.
The following series are all from me:

  From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

  The 3rd version of "moving dirty bitmaps to user space".

>From this version, we add x86 and ppc and asm-generic people to CC lists.


[To KVM people]

Sorry for being late to reply your comments.

Avi,
 - I've wrote an answer to your question in patch 5/12: drivers/vhost/vhost.c .

 - I've considered to change the set_bit_user_non_atomic to an inline function,
   but did not change because the other helpers in the uaccess.h are written as
   macros. Anyway, I hope that x86 people will give us appropriate suggestions
   about this.

 - I thought that documenting about making bitmaps 64-bit aligned will be
   written when we add an API to register user-allocated bitmaps. So probably
   in the next series.

Avi, Alex,
 - Could you check the ia64 and ppc parts, please? I tried to keep the logical
   changes as small as possible.

   I personally tried to build these with cross compilers. For ia64, I could check
   build success with my patch series. But book3s, even without my patch series,
   it failed with the following errors:

  arch/powerpc/kvm/book3s_paired_singles.c: In function 'kvmppc_emulate_paired_single':
  arch/powerpc/kvm/book3s_paired_singles.c:1289: error: the frame size of 2288 bytes is larger than 2048 bytes
  make[1]: *** [arch/powerpc/kvm/book3s_paired_singles.o] Error 1
  make: *** [arch/powerpc/kvm] Error 2


About changelog: there are two main changes from the 2nd version:
  1. I changed the treatment of clean slots (see patch 1/12).
     This was already applied today, thanks!
  2. I changed the switch API. (see patch 11/12).

To show this API's advantage, I also did a test (see the end of this mail).


[To x86 people]

Hi, Thomas, Ingo, Peter,

Please review the patches 4,5/12. Because this is the first experience for
me to send patches to x86, please tell me if this lacks anything.


[To ppc people]

Hi, Benjamin, Paul, Alex,

Please see the patches 6,7/12. I first say sorry for that I've not tested these
yet. In that sense, these may not be in the quality for precise reviews. But I
will be happy if you would give me any comments.

Alex, could you help me? Though I have a plan to get PPC box in the future,
currently I cannot test these.



[To asm-generic people]

Hi, Arnd,

Please review the patch 8/12. This kind of macro is acceptable?





[Performance test]

We measured the tsc needed to the ioctl()s for getting dirty logs in
kernel.

Test environment

  AMD Phenom(tm) 9850 Quad-Core Processor with 8GB memory


1. GUI test (running Ubuntu guest in graphical mode)

  sudo qemu-system-x86_64 -hda dirtylog_test.img -boot c -m 4192 -net ...

We show a relatively stable part to compare how much time is needed
for the basic parts of dirty log ioctl.

                           get.org   get.opt  switch.opt

slots[7].len=32768          278379     66398     64024
slots[8].len=32768          181246       270       160
slots[7].len=32768          263961     64673     64494
slots[8].len=32768          181655       265       160
slots[7].len=32768          263736     64701     64610
slots[8].len=32768          182785       267       160
slots[7].len=32768          260925     65360     65042
slots[8].len=32768          182579       264       160
slots[7].len=32768          267823     65915     65682
slots[8].len=32768          186350       271       160

At a glance, we know our optimization improved significantly compared
to the original get dirty log ioctl. This is true for both get.opt and
switch.opt. This has a really big impact for the personal KVM users who
drive KVM in GUI mode on their usual PCs.

Next, we notice that switch.opt improved a hundred nano seconds or so for
these slots. Although this may sound a bit tiny improvement, we can feel
this as a difference of GUI's responses like mouse reactions.

To feel the difference, please try GUI on your PC with our patch series!


2. Live-migration test (4GB guest, write loop with 1GB buf)

We also did a live-migration test.

                           get.org   get.opt  switch.opt

slots[0].len=655360         797383    261144    222181
slots[1].len=3757047808    2186721   1965244   1842824
slots[2].len=637534208     1433562   1012723   1031213
slots[3].len=131072         216858       331       331
slots[4].len=131072         121635       225       164
slots[5].len=131072         120863       356       164
slots[6].len=16777216       121746      1133       156
slots[7].len=32768          120415       230       278
slots[8].len=32768          120368       216       149
slots[0].len=655360         806497    194710    223582
slots[1].len=3757047808    2142922   1878025   1895369
slots[2].len=637534208     1386512   1021309   1000345
slots[3].len=131072         221118       459       296
slots[4].len=131072         121516       272       166
slots[5].len=131072         122652       244       173
slots[6].len=16777216       123226     99185       149
slots[7].len=32768          121803       457       505
slots[8].len=32768          121586       216       155
slots[0].len=655360         766113    211317    213179
slots[1].len=3757047808    2155662   1974790   1842361
slots[2].len=637534208     1481411   1020004   1031352
slots[3].len=131072         223100       351       295
slots[4].len=131072         122982       436       164
slots[5].len=131072         122100       300       503
slots[6].len=16777216       123653       779       151
slots[7].len=32768          122617       284       157
slots[8].len=32768          122737       253       149

For slots other than 0,1,2 we can see the similar improvement.

Considering the fact that switch.opt does not depend on the bitmap length
except for kvm_mmu_slot_remove_write_access(), this is the cause of some
usec to msec time consumption: there might be some context switches.

But note that this was done with the workload which dirtied the memory
endlessly during the live-migration.

In usual workload, the number of dirty pages varies a lot for each iteration
and we should gain really a lot for relatively clean cases.
