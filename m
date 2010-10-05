Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0JEFDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:03:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46241 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0JEFDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eY9YjAUzpdrzaO9kYnYEzWACemQzeEdQ9iMbgCqIE6BPcVF2/e27a/cHhMVulWSeMm
         zXsYruT9Sl5o+zkD5eSt+AvaQsiv2Yn6yqgyq1JXUe9/Z2cAt+5XQZWHcETm7FKrMhXs
         Cw9NpRIKD1nM85U82PFG6Rk4zK3WqH3wvzH5g=
Date: Mon, 4 Oct 2010 22:03:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux Input <linux-input@vger.kernel.org>
Subject: Sysctl locking?
Message-ID: <20101005050335.GA15355@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried tracing through sysctl code and it appears that there is no
generic locking for reads and writes to a sysctl node and thus a patch
like below is needed if proc_handler is a bit more complex than simply
storing an integer value.

Am I missing something?

Thanks.

--  
Dmitry

Input: mac mouse emulation - add locking

We need to add appropriate locking when toggling mac mouse emulation
on and off to ensure that input device and handler are in consistent
state.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/macintosh/mac_hid.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 067f996..6a82388 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -23,6 +23,8 @@ static int mouse_button3_keycode = KEY_RIGHTALT;	/* right option key */
 
 static struct input_dev *mac_hid_emumouse_dev;
 
+static DEFINE_MUTEX(mac_hid_emumouse_mutex);
+
 static int mac_hid_create_emumouse(void)
 {
 	static struct lock_class_key mac_hid_emumouse_dev_event_class;
@@ -187,6 +189,10 @@ static int mac_hid_toggle_emumouse(ctl_table *table, int write,
 	int old_val = *valp;
 	int rc;
 
+	rc = mutex_lock_killable(&mac_hid_emumouse_mutex);
+	if (rc)
+		return rc;
+
 	rc = proc_dointvec(table, write, buffer, lenp, ppos);
 
 	if (rc == 0 && write && *valp != old_val) {
@@ -202,6 +208,8 @@ static int mac_hid_toggle_emumouse(ctl_table *table, int write,
 	if (rc)
 		*valp = old_val;
 
+	mutex_unlock(&mac_hid_emumouse_mutex);
+
 	return rc;
 }
 
