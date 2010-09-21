Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0IURcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:32:02 -0400
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:35917 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab0IURb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:31:59 -0400
From: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH 2/2] Fix QT4 moc, cflags libs detection on dual QT3/Qt4 systems
Date: Tue, 21 Sep 2010 19:31:31 +0200
Message-Id: <1285090291-11247-2-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <201009181022.31547.edt@aei.ca>
References: <201009181022.31547.edt@aei.ca>
X-Spam-Score: -0.9 (/)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-0.9 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.1 TVD_RCVD_IP TVD_RCVD_IP
 --- Ende Textanalyse
X-Scan-Signature: 1eda448be3d4df409c597eaefe2c9e50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On system with QT3 and QT4 qmake in PATH may be from QT3. So we use
pkg-config for proper QT4 detection.
By reqesting cflags and libs for either QtCore, QtGui and QtSupport include
dirs and libs get listed several times, but so we won't mis anything

CC: Michal Marek <mmarek@suse.cz>
Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
---
 scripts/kconfig/Makefile |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index cb02b1e..321aa67 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -274,12 +274,10 @@ $(obj)/.tmp_qtcheck:
 	      moc="/usr/bin/moc"; \
 	    fi; \
 	else \
-	  headerpath="\$$(shell qmake -query QT_INSTALL_HEADERS)"; \
-	  libpath="\$$(shell qmake -query QT_INSTALL_LIBS)"; \
-	  binpath="\$$(shell qmake -query QT_INSTALL_BINS)"; \
-	  cflags="-I$$headerpath -I$$headerpath/QtCore -I$$headerpath/QtGui -I$$headerpath/Qt3Support -DQT3_SUPPORT"; \
-	  libs="-L$$libpath -Wl,-rpath,$$libpath -lQtCore -lQtGui -lQt3Support"; \
-	  moc="$$binpath/moc"; \
+	  cflags="\$$(shell pkg-config QtCore --cflags) \$$(shell pkg-config QtGui --cflags) \$$(shell pkg-config Qt3Support --cflags)"; \
+	  libs="\$$(shell pkg-config QtCore --libs) \$$(shell pkg-config QtGui --libs) \$$(shell pkg-config Qt3Support --libs)"; \
+	  binpath="\$$(shell pkg-config QtCore --variable=prefix)"; \
+	  moc="$$binpath/bin/moc"; \
 	fi; \
 	echo "KC_QT_CFLAGS=$$cflags" > $@; \
 	echo "KC_QT_LIBS=$$libs" >> $@; \
-- 
1.7.3

