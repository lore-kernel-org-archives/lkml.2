Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0DUH7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 03:59:06 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34136 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0DUH7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 03:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=NRR6UYwhMo1O+hpsCmSwpGSzEKtzkdoLqX8dqLl+jgZrRaGpD5TZyluOMcUhtPDtF2
         6D3dLkpX0AL2IjjCSLy0VOoD+94rgWQV38nLaUdlPdWVmiYOVRN7y56g4a4xm3muAEBO
         nwWGeSXXPIlWlJP+0H4/kG3D0mbwrBbeB0keA=
MIME-Version: 1.0
Date: Wed, 21 Apr 2010 03:59:00 -0400
X-Google-Sender-Auth: 82a901f936dfce67
Message-ID: <o2x3d81e70e1004210059k5184a7c3odf1b228ceefa5571@mail.gmail.com>
Subject: Is memory barrier really needed in unlock_new_inode?
From: Abhinav Duggal <abhinav@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I am trying to understand the barrier in unlock_new_inode and I am not
sure whether the barrier is needed or not.
I am looking at kernel 2.6.34-rc2.
According to the Intel Architecture manual the CPU would not reorder
writes from software point of view. So it should not be a problem on
Intel. I think AMD also does not reorder writes. So it should not be a
problem there also. It could be a problem on Alpha or other arch. but
I am not sure. If only Alpha or others need it shouldn't it be changed
to smp_read_barrier_depends or something. I am not an expert on memory
barriers but I am trying to understand their use and look at places
where they might not be necessary.

Anyways, the comment says
However we must emit the memory barrier so that other CPUs reliably
   * see the clearing of I_NEW after the other inode initialisation has
   * completed.
   */
  smp_mb();
  WARN_ON(!(inode->i_state & I_NEW));
  inode->i_state &= ~I_NEW;
I went through the original post on this at
http://lkml.indiana.edu/hypermail/linux/kernel/0909.1/00103.html

So the comment says that this barrier is prevents writes from
reordering i.e. clearing of I_NEW and previous writes to inode fields.
But write reorder cannot happen on  Intel and AMD so shouldn't it be
changed to some architecture specific barrier who require it. I am
confused.Could anyone explain this?
The thread says that it solves the problem of corruption of ext3 with
nfs. How could the problem occur if writes are not reordered. Is it
that old Intel CPUs allowed writes reordering and the new ones won't
allow or something?Or the corruption occurs on some other CPUs which
do not have such strong guarantees.
I think we can remove this memory barrier if it is not necessary but I
am not sure.
Please look into this and tell me what are your views.
With Regards,
Abhinav.
