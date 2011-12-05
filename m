Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab1LEV0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:26:54 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44659 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab1LEV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:26:53 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/2] PM / request_firmware(): Use the refcounting solution to
 fix the race
To: gregkh@suse.de
Cc: dhowells@redhat.com, eparis@redhat.com, rjw@sisk.pl, kay.sievers@vrfy.org,
        jmorris@namei.org, tj@kernel.org, bp@amd64.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 06 Dec 2011 02:56:41 +0530
Message-ID: <20111205212623.27496.81640.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com>
References: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120521-8878-0000-0000-00000077ED5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is racy to merely call usermodehelper_is_disabled() to check whether
we can successfully use usermodehelpers to get firmware from userspace,
because, an event such as suspend/hibernation in progress could disable
the usermodehelpers at the same time.
So use the pair [get|put]_usermodehelper() around the above check (reader),
to solve this race. Also, the writers, namely usermodehelper_[disable|enable]
should use umh_control_[begin|done] for this synchronization to be effective.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/base/firmware_class.c |    3 +++
 kernel/kmod.c                 |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 06ed6b4..8a04946 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -534,6 +534,8 @@ static int _request_firmware(const struct firmware **firmware_p,
 		return 0;
 	}
 
+	get_usermodehelper();
+
 	if (WARN_ON(usermodehelper_is_disabled())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
@@ -572,6 +574,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 	fw_destroy_instance(fw_priv);
 
 out:
+	put_usermodehelper();
 	if (retval) {
 		release_firmware(firmware);
 		*firmware_p = NULL;
diff --git a/kernel/kmod.c b/kernel/kmod.c
index acb52af..e6951b3 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -337,6 +337,8 @@ static void __call_usermodehelper(struct work_struct *work)
  * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
  * (used for preventing user land processes from being created after the user
  * land has been frozen during a system-wide hibernation or suspend operation).
+ * Should always be manipulated under umhelper.lock, by using the functions
+ * umh_control_begin() and umh_control_done().
  */
 static int usermodehelper_disabled = 1;
 
@@ -362,8 +364,10 @@ int usermodehelper_disable(void)
 {
 	long retval;
 
+	umh_control_begin();
 	usermodehelper_disabled = 1;
-	smp_mb();
+	umh_control_done();
+
 	/*
 	 * From now on call_usermodehelper_exec() won't start any new
 	 * helpers, so it is sufficient if running_helpers turns out to
@@ -376,7 +380,9 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
+	umh_control_begin();
 	usermodehelper_disabled = 0;
+	umh_control_done();
 	return -EAGAIN;
 }
 
@@ -385,7 +391,9 @@ int usermodehelper_disable(void)
  */
 void usermodehelper_enable(void)
 {
+	umh_control_begin();
 	usermodehelper_disabled = 0;
+	umh_control_done();
 }
 
 /**

