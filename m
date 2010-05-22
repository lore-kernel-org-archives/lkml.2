Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab0EVAoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:44:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab0EVAoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:44:20 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] compat-wireless: add linux-next-pending, crap patch dirs and nagometer
Date: Fri, 21 May 2010 20:44:19 -0400
Message-Id: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes you have no other option but to carry around patches.
This can happen for a variety of reasons. Ultimately testing of code
cannot happen on the kernel maintainer's clock but on your own.

This expands the idea of the linux-next-cherry-pick patch directory
on compat-wireless to also allow for patches to be merged which are
posted to some mailing list but pending merge due to some reasons
(merge window is a good example). It also adds a crap patch directory
for those really nasty situations you can run into where you have
no other option but to give someone a release with some delta even
if the patch is not yet posted anywhere.

The focus should always be upstream though so to avoid these
situations we will also provide code metrics to indicate to
the package maintainer how much code came from each directory,
including the backport code to support older kernel releases.

Maybe we should add the code-metrics.txt file as a print out
on the compat module load :)

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 crap/README               |   17 ++++++
 linux-next-pending/README |   17 ++++++
 scripts/admin-update.sh   |  130 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 156 insertions(+), 8 deletions(-)
 create mode 100644 crap/README
 create mode 100644 linux-next-pending/README

diff --git a/crap/README b/crap/README
new file mode 100644
index 0000000..c1b512e
--- /dev/null
+++ b/crap/README
@@ -0,0 +1,17 @@
+
+compat-wireless crap patches
+============================
+
+If you are including patches into this directory you
+must be fixing some critical bug for a customer which needs
+immediate release or immediate testing.
+
+Alternatively you would use this to apply some sort of
+crap code you are maintaining.
+
+You must have a really good reason to be adding files
+in this directory. If possible you should explain your
+reasoning of why the patch is getting included here and
+not upstream and why it hasn't even yet been posted.
+
+You should avoid these patches at all costs.
diff --git a/linux-next-pending/README b/linux-next-pending/README
new file mode 100644
index 0000000..cc531b2
--- /dev/null
+++ b/linux-next-pending/README
@@ -0,0 +1,17 @@
+
+compat-wireless linux-next-pending patches
+==========================================
+
+You must have a really good reason to be adding files
+in this directory. The requirement is your patches must have
+been posted to a public mailing list for the subsystem you are
+working on. Each patch you add here must have a really good
+explanation on the top of the file which clarifies why the
+patch has not yet been merged.
+
+We try to avoid having patch files because but we understand
+if you might because you need to test code posted but not yet
+merged into linux-next or a stable kernel release. This can happen
+often during the merge window, when the maintainers are unavailable,
+on vacation, suck at what they do, or for any other uncontrollable
+reasons.
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 78a8c63..98c21a9 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 # 
-# Copyright 2007, 2008	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+# Copyright 2007, 2008, 2010	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
 #
 # Use this to update compat-wireless-2.6 to the latest
 # wireless-testing.git tree you have.
@@ -45,6 +45,112 @@ CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
 NET_DIRS="wireless mac80211 rfkill"
+CODE_METRICS=code-metrics.txt
+
+usage() {
+	printf "Usage: $0 [ refresh] [ --help | -h | -n | -p | -c ]\n"
+
+	printf "${GREEN}%10s${NORMAL} - will update your all your patch offsets using quilt\n" "refresh"
+	printf "${GREEN}%10s${NORMAL} - apply the patches linux-next-cherry-picks directory\n" "-n"
+	printf "${GREEN}%10s${NORMAL} - apply the patches on the linux-next-pending directory\n" "-p"
+	printf "${GREEN}%10s${NORMAL} - apply the patches on the crap directory\n" "-c"
+}
+
+brag_backport() {
+	printf "${GREEN}%10s${NORMAL} - backport code changes\n" $2
+	printf "${GREEN}%10s${NORMAL} - backport code additions\n" $3
+	printf "${GREEN}%10s${NORMAL} - backport code deletions\n" $4
+	printf "${RED}%10s${NORMAL} - %% of code consists of backport work\n" $(perl -e 'printf("%.2f", 100 * '$2' / '$1');')
+}
+
+nag_next_cherry_pick() {
+	printf "${YELLOW}%10s${NORMAL} - Code changes brought in from linux-next\n" $2
+	printf "${YELLOW}%10s${NORMAL} - Code additions brought in from linux-next\n" $3
+	printf "${YELLOW}%10s${NORMAL} - Code deletions brought in from linux-next\n" $4
+	printf "${REG}%10s${NORMAL} - %% of code being cherry picked from linux-next\n" $(perl -e 'printf("%.2f", 100 * '$2' / '$1');')
+}
+
+nag_pending() {
+	printf "${YELLOW}%10s${NORMAL} - Code changes posted but not yet merged\n" $2
+	printf "${YELLOW}%10s${NORMAL} - Code additions posted but not yet merged\n" $3
+	printf "${YELLOW}%10s${NORMAL} - Code deletions posted but not yet merged\n" $4
+	printf "${REG}%10s${NORMAL} - %% of code not yet merged\n" $(perl -e 'printf("%.2f", 100 * '$2' / '$1');')
+}
+
+nag_crap() {
+	printf "${RED}%10s${NORMAL} - Crap changes not yet posted\n" $2
+	printf "${RED}%10s${NORMAL} - Crap additions not yet merged\n" $3
+	printf "${RED}%10s${NORMAL} - Crap deletions not yet posted\n" $4
+	printf "${REG}%10s${NORMAL} - %% of crap code\n" $(perl -e 'printf("%.2f", 100 * '$2' / '$1');')
+}
+
+nagometer() {
+	CHANGES=0
+
+	ORIG_CODE=$2
+	ADD=$(grep -c ^+ $1/*.patch| awk -F":" 'BEGIN {sum=0} {sum += $2} END { print sum}')
+	DEL=$(grep -c ^- $1/*.patch| awk -F":" 'BEGIN {sum=0} {sum += $2} END { print sum}')
+	# Total code is irrelevant unless you take into account each part,
+	# easier to just compare against the original code.
+	# let TOTAL_CODE=$ORIG_CODE+$ADD-$DEL
+
+	let CHANGES=$ADD+$DEL
+
+	case $1 in
+	"patches")
+		brag_backport $ORIG_CODE $CHANGES $ADD $DEL
+		;;
+	"linux-next-cherry-picks")
+		nag_next_cherry_pick $ORIG_CODE $CHANGES $ADD $DEL
+		;;
+	"linux-next-pending")
+		nag_pending $ORIG_CODE $CHANGES $ADD $DEL
+		;;
+	"crap")
+		nag_crap $ORIG_CODE $CHANGES $ADD $DEL
+		;;
+	*)
+		;;
+	esac
+
+}
+
+EXTRA_PATCHES="patches"
+REFRESH="n"
+if [ $# -ge 1 ]; then
+	if [ $# -gt 4 ]; then
+		usage $0
+		exit
+	fi
+	if [[ $1 = "-h" || $1 = "--help" ]]; then
+		usage $0
+		exit
+	fi
+	while [ $# -ne 0 ]; do
+		if [[ "$1" = "-n" ]]; then
+			EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-cherry-picks"
+			shift; continue;
+		fi
+		if [[ "$1" = "-p" ]]; then
+			EXTRA_PATCHES="${EXTRA_PATCHES} linux-next-pending"
+			shift; continue;
+		fi
+		if [[ "$1" = "-c" ]]; then
+			EXTRA_PATCHES="${EXTRA_PATCHES} crap"
+			shift; continue;
+		fi
+		if [[ "$1" = "refresh" ]]; then
+			REFRESH="y"
+			shift; continue;
+		fi
+
+		echo "Unexpected argument passed: $1"
+		usage $0
+		exit
+	done
+
+fi
+
 # User exported this variable
 if [ -z $GIT_TREE ]; then
 	GIT_TREE="/home/$USER/linux-next/"
@@ -274,12 +380,17 @@ patchRefresh() {
 	rm -rf patches.orig .pc $1/series
 }
 
-if [[ "$1" = "refresh" ]]; then
-	patchRefresh patches
-	patchRefresh linux-next-cherry-picks
+if [[ "$REFRESH" = "y" ]]; then
+	for dir in $EXTRA_PATCHES; do
+		patchRefresh $dir
+	done
 fi
 
-for dir in patches linux-next-cherry-picks; do
+ORIG_CODE=$(find ./ -type f -name \*.[ch]| xargs wc -l | tail -1 | awk '{print $1}')
+printf "\n${CYAN}compat-wireless code metrics${NORMAL}\n\n" > $CODE_METRICS
+printf "${PURPLE}%10s${NORMAL} - Total upstream code being pulled\n" $ORIG_CODE >> $CODE_METRICS
+
+for dir in $EXTRA_PATCHES; do
 	FOUND=$(find $dir/ -name \*.patch | wc -l)
 	if [ $FOUND -eq 0 ]; then
 		continue
@@ -293,6 +404,7 @@ for dir in patches linux-next-cherry-picks; do
 			exit $RET
 		fi
 	done
+	nagometer $dir $ORIG_CODE >> $CODE_METRICS
 done
 
 DIR="$PWD"
@@ -342,9 +454,11 @@ if [ -d ./.git ]; then
 	esac
 
 	cd $DIR
-	echo -e "Base tree: ${GREEN}$(cat compat_base_tree)${NORMAL}"
-	echo -e "Base tree version: ${PURPLE}$(cat compat_base_tree_version)${NORMAL}"
-	echo -e "compat-wireless release: ${YELLOW}$(cat compat_version)${NORMAL}"
+	echo -e "\nBase tree: ${GREEN}$(cat compat_base_tree)${NORMAL}" >> $CODE_METRICS
+	echo -e "Base tree version: ${PURPLE}$(cat compat_base_tree_version)${NORMAL}" >> $CODE_METRICS
+	echo -e "compat-wireless release: ${YELLOW}$(cat compat_version)${NORMAL}" >> $CODE_METRICS
+
+	cat $CODE_METRICS
 fi
 
 ./scripts/driver-select restore
-- 
1.6.3.3

