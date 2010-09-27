Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253Ab0I0W0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:26:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39157 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0I0W0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:26:30 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, stable-review@linux.kernel.org
Subject: [PATCH] compat-wireless: add support for generating pending-stable/ fixes
Date: Mon, 27 Sep 2010 18:26:28 -0400
Message-Id: <1285626388-17383-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often right before the merge window we get a block on non
oops/regression fixes for stable fixes. Some stable fixes
often get propagated afterwards during the extraversion
maintenance of the kernels. Right before the merge window
circa rc4 and rc5 subsystem maintainers get pegged if they
throw in non oops/regression fixes for Linus or their
respective upstream maintainer. While this makes sense
for tree management and stable release considerations we
still need to get users some stable patches propagated.
We can achieve this in compat-wireless with the -s option to
./scripts/admin-update.sh which this patch implements. You
will need to use a stable branch of compat-wireless, point
it to a stable git tree, and have present a linux-next git
tree. The -s option will get your $(git describe --abbrev=0)
from your stable tree and then get all pending fixes via:

git format-patch --grep="stable@kernel.org" \
	-o pending-stable/ $(git describe --abbrev=0)..HEAD $WSTABLE

Where WSTABLE is:

export WSTABLE="
        net/wireless/
        net/wireless/
        net/mac80211/
        net/rfkill/
        drivers/net/wireless/
        net/bluetooth/
        drivers/bluetooth/
        drivers/net/atl1c/
        drivers/net/atl1e/
        drivers/net/atlx/
        include/linux/nl80211.h
        include/linux/rfkill.h
        include/net/cfg80211.h
        include/net/regulatory.h
        include/net/cfg80211.h"

What this does is get us all pending stable fixes on linux-next.git
not yet merged onto Linus' tree. This lets us hurry in stable fixes
for users for stable releases of compat-wireless based on the RC
series. This accelerates the pace of fix propagation right before
the merge window.

To generate and apply your own stable fixes to your stable compa-wireless
releases you will then use:

./scripts/admin-updates.sh -s

The -s both generates new pending stable fix patches applies the
patches from the pending-stable/ directory. I'm up to support stable
releases with pending-stable/ applied, not sure if its worth it to
have two releases, one with it and one without buf if there are
considerations for this please let me know and I'll just make two
releases. For now I'll make the releases with the stable patches
merged with the requirement they must at least be on the linux-next.git
tree to promote upstreamabilty (is that a word?).

If you want to review the pending-stable/ picked patches check out the
pending-stable/ directory on the respective stable compat-wireless release.
Note that for non-stable releases you can also use the linux-next-cherry-picks/
directory, that gives distributions/vendors the flexibility to cherry pick out
non-stable fixes from linux-next.git for a stable release. For the big
fat warning as why this should be avoided check the README on that directory.

The pending-stable/ directory may also help the stable team maintainers on
their crusade when applying patches onto stable, it also means we will
need respective backports at least to Linus' tree for each stable patch.
Right now I get 23 pending stable patches based on today's linux-next.git
and Linus' v2.6.36-rc5 tag, which *should* in theory get propagated to
the first extraversion release of the kernel onto v2.6.36.1 (we'll see!).

Cc: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable-review@linux.kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 pending-stable/README   |   23 +++++++++++++++++
 scripts/admin-update.sh |   61 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletions(-)
 create mode 100644 pending-stable/README

As an example, these are the current pending-stable/ patches I get so far:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ ls -1 pending-stable/
0001-p54usb-fix-off-by-one-on-CONFIG_PM.patch
0002-mac80211-Fix-signal-strength-average-initialization-.patch
0003-ath9k-fix-spurious-MIC-failure-reports.patch
0004-ath9k_hw-handle-rx-key-miss.patch
0005-mac80211-use-correct-station-flags-lock.patch
0006-ath9k-fix-power-save-race-conditions.patch
0007-ath9k-fix-regression-on-beacon-loss-after-bgscan.patch
0008-ath9k-fix-enabling-ANI-tx-monitor-after-bg-scan.patch
0009-mac80211-add-helper-for-reseting-the-connection-moni.patch
0010-mac80211-reset-probe-send-counter-upon-connection-ti.patch
0011-mac80211-reset-connection-idle-when-going-offchannel.patch
0012-mac80211-make-the-beacon-monitor-available-externall.patch
0013-mac80211-disable-beacon-monitor-while-going-offchann.patch
0014-mac80211-send-last-3-5-probe-requests-as-unicast.patch
0015-ath9k-fix-regression-which-prevents-chip-sleep-after.patch
0016-ath9k-fix-regression-which-disabled-ps-on-ath9k.patch
0017-wext-fix-potential-private-ioctl-memory-content-leak.patch
0018-ath9k-fix-an-aggregation-start-related-race-conditio.patch
0019-ath9k-clean-up-fix-aggregation-session-flush.patch
0020-atl1-fix-resume.patch
0021-mac80211-fix-use-after-free.patch
0022-mac80211-clear-txflags-for-ps-filtered-frames.patch
0023-ath9k-Fix-tx-struck-state-with-paprd.patch

diff --git a/pending-stable/README b/pending-stable/README
new file mode 100644
index 0000000..d366977
--- /dev/null
+++ b/pending-stable/README
@@ -0,0 +1,23 @@
+compat-wireless pending-stable/ patches
+=======================================
+
+Often right before the merge window we get a block on non
+oops/regression fixes for stable fixes. Some stable fixes
+often get propagated afterwards during the extraversion
+maintenance of the kernels. Right before the merge window
+circa rc4 and rc5 subsystem maintainers get pegged if they
+throw in non oops/regression fixes for Linus or their
+respective upstream maintainer. While this makes sense
+for tree management and stable release considerations we
+still need to get users some stable patches propagated.
+
+This directory is there to help with that. Only patches
+which have been merged into linux-next.git will be included
+in this directory which means you must post it and the maintainer
+should have merged it and Stephen would have picked it up.
+
+This directory will always be empty for bleeding edge
+releases as bleeding edge releases are always based on
+linux-next already. This directory only makes sense for
+stable release of the kernel, and it we will always try
+to use it, in case there are stable fixes not yet propagated.
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 8ff2ece..2d49916 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -48,9 +48,10 @@ NET_DIRS="wireless mac80211 rfkill"
 CODE_METRICS=code-metrics.txt
 
 usage() {
-	printf "Usage: $0 [ refresh] [ --help | -h | -n | -p | -c ]\n"
+	printf "Usage: $0 [ refresh] [ --help | -h | -s | -n | -p | -c ]\n"
 
 	printf "${GREEN}%10s${NORMAL} - will update your all your patch offsets using quilt\n" "refresh"
+	printf "${GREEN}%10s${NORMAL} - get and apply pending-stable/ fixes purging old files there\n" "-s"
 	printf "${GREEN}%10s${NORMAL} - apply the patches linux-next-cherry-picks directory\n" "-n"
 	printf "${GREEN}%10s${NORMAL} - apply the patches on the linux-next-pending directory\n" "-p"
 	printf "${GREEN}%10s${NORMAL} - apply the patches on the crap directory\n" "-c"
@@ -123,6 +124,7 @@ nagometer() {
 
 EXTRA_PATCHES="patches"
 REFRESH="n"
+GET_STABLE_PENDING="n"
 if [ $# -ge 1 ]; then
 	if [ $# -gt 4 ]; then
 		usage $0
@@ -133,6 +135,11 @@ if [ $# -ge 1 ]; then
 		exit
 	fi
 	while [ $# -ne 0 ]; do
+		if [[ "$1" = "-s" ]]; then
+			GET_STABLE_PENDING="y"
+			EXTRA_PATCHES="${EXTRA_PATCHES} pending-stable" 
+			shift; continue;
+		fi
 		if [[ "$1" = "-n" ]]; then
 			EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-cherry-picks"
 			shift; continue;
@@ -357,6 +364,58 @@ cp -a $GIT_COMPAT_TREE/include/trace/* include/trace/
 cp -a $GIT_COMPAT_TREE/include/pcmcia/* include/pcmcia/
 rm -f $COMPAT/*.mod.c
 
+# files we suck in for compat-wireless
+export WSTABLE="
+        net/wireless/
+        net/wireless/
+        net/mac80211/
+        net/rfkill/
+        drivers/net/wireless/
+        net/bluetooth/
+        drivers/bluetooth/
+        drivers/net/atl1c/
+        drivers/net/atl1e/
+        drivers/net/atlx/
+        include/linux/nl80211.h
+        include/linux/rfkill.h
+        include/net/cfg80211.h
+        include/net/regulatory.h
+        include/net/cfg80211.h"
+
+# Stable pending, if -n was passed
+if [[ "$GET_STABLE_PENDING" = y ]]; then
+	LAST_DIR=$PWD
+	cd $GIT_TREE
+	if [ -f localversion* ]; then
+		echo -e "You should be using a stable tree to use the -s option"
+		exit 1
+	fi
+
+	# we now assume you are using a stable tree
+	cd $GIT_TREE
+	LAST_STABLE_UPDATE=$(git describe --abbrev=0)
+	NEXT_TREE="/home/$USER/linux-next/"
+	if [ ! -d $NEXT_TREE ]; then
+		echo -e "You are expected to have $NEXT_TREE directory when using -s"
+		exit 1
+	fi
+	cd $NEXT_TREE
+	PENDING_STABLE_DIR="pending-stable/"
+
+	rm -rf $CHERRY_PICK_DIR
+	echo -e "${GREEN}Generating stable cherry picks... ${NORMAL}"
+	git format-patch --grep="stable@kernel.org" -o $PENDING_STABLE_DIR ${LAST_STABLE_UPDATE}.. $WSTABLE
+	if [ ! -d ${LAST_DIR}/${PENDING_STABLE_DIR} ]; then
+		echo -e "Assumption that ${LAST_DIR}/${PENDING_STABLE_DIR} directory exists failed"
+		exit 1
+	fi
+	echo -e "${GREEN}Purging old stable cherry picks... ${NORMAL}"
+	rm -f ${LAST_DIR}/${PENDING_STABLE_DIR}/*.patch
+	cp ${PENDING_STABLE_DIR}/*.patch ${LAST_DIR}/${PENDING_STABLE_DIR}/
+	echo -e "${GREEN}Updated stable cherry picks, review with git diff and update hunks with ./scripts/admin-update.sh -s refresh${NORMAL}"
+	cd $LAST_DIR
+fi
+
 # Refresh patches using quilt
 patchRefresh() {
 	if [ -d patches.orig ] ; then
-- 
1.7.0.4

