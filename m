Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2BTPUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:20:51 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:36054 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2BTPUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:20:50 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        kexec-list <kexec@lists.infradead.org>
Date: Mon, 20 Feb 2012 10:20:34 -0500
Subject: RE: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Thread-Topic: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Thread-Index: AczgXvIDVxCWg0nLSAmqY/AKxn2xpwPgWjLA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DAC909D43@USINDEVS01.corp.hds.com>
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1202200134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -void disable_IO_APIC(void)
> +void disable_IO_APIC(int force)
> {
> 	/*
>+	 * Use force to bust the io_apic spinlock
>+	 *
>+	 * There is a case where kdump can race with irq
>+	 * migration such that kdump will inject an NMI
>+	 * while another cpu holds the ioapic_lock to
>+	 * migrate the irq.  This would cause a deadlock.
>+	 *
>+	 * Because kdump stops all the cpus, we can safely
>+	 * bust the spinlock as we are just clearing the
>+	 * io apic anyway.
>+	 */
>+	if (force && spin_is_locked(&ioapic_lock))
>+		/* only one cpu should be running now */
>+		spin_lock_init(&ioapic_lock);
>+
>+	/*

Hmm...

This patch solves the kdump race, but it may make us confuse when we analyze vmcore,
Because it clears value of ioapic_lock without notice.

It kernel panic is related to IO_APIC, they will check value of ioapic_lock.

So, it is better if we can restore the value of ioapic_lock after calling disable_IO_APIC(),  
IOW, my idea is following.
 - Backup value of ioapic_lock
 - Bust ioapic_lock
 -  Call disable_IO_APIC()
 - Restore value of ioapic_lock

But, as you are discussing with Eric, we don't need to worry about this if we can completely remove disable_IO_APIC().

Seiji


