Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab1EYNS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab1EYNS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:18:56 -0400
Date: Wed, 25 May 2011 15:18:54 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hiromu Yakura <hiromu1996@gmail.com>
Subject: Re: [PATCH] xconfig: merge code path to conf_write()
Message-ID: <20110525131854.GF2276@sepie.suse.cz>
References: <1306260978-29437-1-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306260978-29437-1-git-send-email-lacombar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 02:16:18PM -0400, Arnaud Lacombe wrote:
> Avoid to have multiple path saving the config. This fixes an error check miss
> when the window is being closed and the user requested the config to be written.
> 
> Reported-by: Hiromu Yakura <hiromu1996@gmail.com>
> Pointed-out-by: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/qconf.cc |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

Applied, thanks.

The following patch avoids the data loss if the configuration cannot be
saved.

Michal

Subject: [PATCH] xconfig: Abort close if configuration cannot be saved

Give the user an opportunity to fix the error or save the configuration
under a different path.

Reported-by: Hiromu Yakura <hiromu1996@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index c2796b8..92bf576 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1478,10 +1478,13 @@ void ConfigMainWindow::loadConfig(void)
 	ConfigView::updateListAll();
 }
 
-void ConfigMainWindow::saveConfig(void)
+bool ConfigMainWindow::saveConfig(void)
 {
-	if (conf_write(NULL))
+	if (conf_write(NULL)) {
 		QMessageBox::information(this, "qconf", _("Unable to save configuration!"));
+		return false;
+	}
+	return true;
 }
 
 void ConfigMainWindow::saveConfigAs(void)
@@ -1642,7 +1645,11 @@ void ConfigMainWindow::closeEvent(QCloseEvent* e)
 	mb.setButtonText(QMessageBox::Cancel, _("Cancel Exit"));
 	switch (mb.exec()) {
 	case QMessageBox::Yes:
-		saveConfig();
+		if (saveConfig())
+			e->accept();
+		else
+			e->ignore();
+		break;
 	case QMessageBox::No:
 		e->accept();
 		break;
diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
index 91677d9..3715b3e 100644
--- a/scripts/kconfig/qconf.h
+++ b/scripts/kconfig/qconf.h
@@ -311,7 +311,7 @@ public slots:
 	void listFocusChanged(void);
 	void goBack(void);
 	void loadConfig(void);
-	void saveConfig(void);
+	bool saveConfig(void);
 	void saveConfigAs(void);
 	void searchConfig(void);
 	void showSingleView(void);
