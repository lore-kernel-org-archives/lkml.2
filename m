Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2JGCqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 22:46:32 -0400
Received: from shutemov.name ([176.9.204.213]:59799 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2JGCqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 22:46:31 -0400
Date: Sun, 7 Oct 2012 05:47:11 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        ".linux-crypto"@vger.kernel.org
Subject: Deadlock on poweroff
Message-ID: <20121007024711.GA21403@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul and all,

With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
poweroff.

It guess it happens because of race for cpu_hotplug.lock:

	CPU A					CPU B
disable_nonboot_cpus()
_cpu_down()
cpu_hotplug_begin()
 mutex_lock(&cpu_hotplug.lock);
__cpu_notify()
padata_cpu_callback()
__padata_remove_cpu()
padata_replace()
synchronize_rcu()
					rcu_gp_kthread()
					get_online_cpus();
					mutex_lock(&cpu_hotplug.lock);

Have you seen the issue before?

-- 
 Kirill A. Shutemov
