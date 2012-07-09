Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2GIHiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:38:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35491 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2GIHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:38:00 -0400
Date: Mon, 9 Jul 2012 10:37:47 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120709103747.5270084d@pixies.home.jungo.com>
In-Reply-To: <4FF9780D.4010709@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
	<20120708144745.36109029@pixies.home.jungo.com>
	<4FF9780D.4010709@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Sun, 08 Jul 2012 14:07:41 +0200 Richard Weinberger <richard@nod.at> wrote:
> > +			/* TODO: in the new locking scheme, produce_free_peb is
> > +			 * called under wl_lock taken.
> > +			 * so when returning, should reacquire the lock
> > +			 */
> 
> Which new locking scheme?

I am diffing linux-ubi fastmap HEAD against its fork point (vanilla
ubi), that's 6b16351..d41a140 on linux-ubi.

Which gives the following diff in produce_free_pebs:

@@ -261,7 +266,6 @@ static int produce_free_peb(struct ubi_device *ubi)
 {
 	int err;
 
-	spin_lock(&ubi->wl_lock);
 	while (!ubi->free.rb_node) {
 		spin_unlock(&ubi->wl_lock);
 
@@ -272,7 +276,6 @@ static int produce_free_peb(struct ubi_device *ubi)
 
 		spin_lock(&ubi->wl_lock);
 	}
-	spin_unlock(&ubi->wl_lock);
 
 	return 0;
 }

Which is probably okay, since you obtain the lock in the new
'ubi_refill_pools', which calls produce_free_peb:

+void ubi_refill_pools(struct ubi_device *ubi)
+{
+	spin_lock(&ubi->wl_lock);
+	refill_wl_pool(ubi);
+	refill_wl_user_pool(ubi);
+	spin_unlock(&ubi->wl_lock);
+}

However if 'do_work' fails within 'produce_free_peb', you return the
error but leave wl_lock unlocked - where it is expected to be locked
(otherwise, ubi_refill_pools will unlock it again):

static int produce_free_peb(struct ubi_device *ubi)
{
	int err;

	while (!ubi->free.rb_node) {
		spin_unlock(&ubi->wl_lock);

		dbg_wl("do one work synchronously");
		err = do_work(ubi);
		if (err)
			return err;

		spin_lock(&ubi->wl_lock);
	}

	return 0;
}

Regards,
Shmulik
