Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab0FQNlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:41:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab0FQNlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:41:11 -0400
From: Michal Marek <mmarek@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: [PATCH] kbuild: Clean up and speed up the localversion logic
Date: Thu, 17 Jun 2010 15:40:38 +0200
Message-Id: <1276782038-23441-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4C1764CD.3080402@suse.cz>
References: <4C1764CD.3080402@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we run scripts/setlocalversion during every build, it makes
sense to move all the localversion logic there. This cleans up the
toplevel Makefile and also makes sure that the script is called only
once in 'make prepare' (previously, it would be called every time due to
a variable expansion in an ifneq statement). No user-visible change is
intended, unless one runs the setlocalversion script directly.

Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---

I tried to test this in various scenarios, but if anyone of you could give
it a try, that would be great. The patch is against 2.6.35-rc3.

---
 Makefile                 |   74 +------------------
 scripts/package/Makefile |    2 +-
 scripts/setlocalversion  |  179 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 136 insertions(+), 119 deletions(-)

diff --git a/Makefile b/Makefile
index d49d96c..f6d2cb2 100644
--- a/Makefile
+++ b/Makefile
@@ -883,80 +883,12 @@ PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
-# Build the kernel release string
-#
-# The KERNELRELEASE value built here is stored in the file
-# include/config/kernel.release, and is used when executing several
-# make targets, such as "make install" or "make modules_install."
-#
-# The eventual kernel release string consists of the following fields,
-# shown in a hierarchical format to show how smaller parts are concatenated
-# to form the larger and final value, with values coming from places like
-# the Makefile, kernel config options, make command line options and/or
-# SCM tag information.
-#
-#	$(KERNELVERSION)
-#	  $(VERSION)			eg, 2
-#	  $(PATCHLEVEL)			eg, 6
-#	  $(SUBLEVEL)			eg, 18
-#	  $(EXTRAVERSION)		eg, -rc6
-#	$(localver-full)
-#	  $(localver)
-#	    localversion*		(files without backups, containing '~')
-#	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
-#	  $(LOCALVERSION)		(from make command line, if provided)
-#	  $(localver-extra)
-#	    $(scm-identifier)		(unique SCM tag, if one exists)
-#	      ./scripts/setlocalversion	(only with CONFIG_LOCALVERSION_AUTO)
-#	      .scmversion		(only with CONFIG_LOCALVERSION_AUTO)
-#	    +				(only without CONFIG_LOCALVERSION_AUTO
-#					 and without LOCALVERSION= and
-#					 repository is at non-tagged commit)
-#
-# For kernels without CONFIG_LOCALVERSION_AUTO compiled from an SCM that has
-# been revised beyond a tagged commit, `+' is appended to the version string
-# when not overridden by using "make LOCALVERSION=".  This indicates that the
-# kernel is not a vanilla release version and has been modified.
-
-pattern = ".*/localversion[^~]*"
-string  = $(shell cat /dev/null \
-	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort -u`)
-
-localver = $(subst $(space),, $(string) \
-			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
-
-# scripts/setlocalversion is called to create a unique identifier if the source
-# is managed by a known SCM and the repository has been revised since the last
-# tagged (release) commit.  The format of the identifier is determined by the
-# SCM's implementation.
-#
-# .scmversion is used when generating rpm packages so we do not loose
-# the version information from the SCM when we do the build of the kernel
-# from the copied source
-ifeq ($(wildcard .scmversion),)
-        scm-identifier = $(shell $(CONFIG_SHELL) \
-                         $(srctree)/scripts/setlocalversion $(srctree))
-else
-        scm-identifier = $(shell cat .scmversion 2> /dev/null)
-endif
-
-ifdef CONFIG_LOCALVERSION_AUTO
-	localver-extra = $(scm-identifier)
-else
-	ifneq ($(scm-identifier),)
-		ifeq ($(LOCALVERSION),)
-			localver-extra = +
-		endif
-	endif
-endif
-
-localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
-
 # Store (new) KERNELRELASE string in include/config/kernel.release
-kernelrelease = $(KERNELVERSION)$(localver-full)
+localversion = $(shell $(CONFIG_SHELL) \
+	       $(srctree)/scripts/setlocalversion $(srctree))
 include/config/kernel.release: include/config/auto.conf FORCE
 	$(Q)rm -f $@
-	$(Q)echo $(kernelrelease) > $@
+	$(Q)echo $(KERNELVERSION)$(localversion) > $@
 
 
 # Things we need to do before we recursively start building the kernel
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 62fcc3a..3a681ef 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -44,7 +44,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 	fi
 	$(MAKE) clean
 	$(PREV) ln -sf $(srctree) $(KERNELPATH)
-	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion > $(objtree)/.scmversion
+	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --scm-only > $(objtree)/.scmversion
 	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
 	$(PREV) rm $(KERNELPATH)
 	rm -f $(objtree)/.scmversion
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 46989b8..d6a866e 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -10,73 +10,158 @@
 #
 
 usage() {
-	echo "Usage: $0 [srctree]" >&2
+	echo "Usage: $0 [--scm-only] [srctree]" >&2
 	exit 1
 }
 
-cd "${1:-.}" || usage
+scm_only=false
+srctree=.
+if test "$1" = "--scm-only"; then
+	scm_only=true
+	shift
+fi
+if test $# -gt 0; then
+	srctree=$1
+	shift
+fi
+if test $# -gt 0 -o ! -d "$srctree"; then
+	usage
+fi
 
-# Check for git and a git repo.
-if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
+scm_version()
+{
+	local short=false
 
-	# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore it,
-	# because this version is defined in the top level Makefile.
-	if [ -z "`git describe --exact-match 2>/dev/null`" ]; then
+	cd "$srctree"
+	if test -e .scmversion; then
+		cat "$_"
+		return
+	fi
+	if test "$1" = "--short"; then
+		short=true
+	fi
 
-		# If we are past a tagged commit (like "v2.6.30-rc5-302-g72357d5"),
-		# we pretty print it.
-		if atag="`git describe 2>/dev/null`"; then
-			echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+	# Check for git and a git repo.
+	if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
+
+		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
+		# it, because this version is defined in the top level Makefile.
+		if [ -z "`git describe --exact-match 2>/dev/null`" ]; then
+
+			# If only the short version is requested, don't bother
+			# running further git commands
+			if $short; then
+				echo "+"
+				return
+			fi
+			# If we are past a tagged commit (like
+			# "v2.6.30-rc5-302-g72357d5"), we pretty print it.
+			if atag="`git describe 2>/dev/null`"; then
+				echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+
+			# If we don't have a tag at all we print -g{commitish}.
+			else
+				printf '%s%s' -g $head
+			fi
+		fi
 
-		# If we don't have a tag at all we print -g{commitish}.
-		else
-			printf '%s%s' -g $head
+		# Is this git on svn?
+		if git config --get svn-remote.svn.url >/dev/null; then
+			printf -- '-svn%s' "`git svn find-rev $head`"
 		fi
-	fi
 
-	# Is this git on svn?
-	if git config --get svn-remote.svn.url >/dev/null; then
-	        printf -- '-svn%s' "`git svn find-rev $head`"
-	fi
+		# Update index only on r/w media
+		[ -w . ] && git update-index --refresh --unmerged > /dev/null
 
-	# Update index only on r/w media
-	[ -w . ] && git update-index --refresh --unmerged > /dev/null
+		# Check for uncommitted changes
+		if git diff-index --name-only HEAD | grep -v "^scripts/package" \
+		    | read dummy; then
+			printf '%s' -dirty
+		fi
 
-	# Check for uncommitted changes
-	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
-	    | read dummy; then
-		printf '%s' -dirty
+		# All done with git
+		return
 	fi
 
-	# All done with git
-	exit
-fi
+	# Check for mercurial and a mercurial repo.
+	if hgid=`hg id 2>/dev/null`; then
+		tag=`printf '%s' "$hgid" | cut -d' ' -f2`
+
+		# Do we have an untagged version?
+		if [ -z "$tag" -o "$tag" = tip ]; then
+			id=`printf '%s' "$hgid" | sed 's/[+ ].*//'`
+			printf '%s%s' -hg "$id"
+		fi
 
-# Check for mercurial and a mercurial repo.
-if hgid=`hg id 2>/dev/null`; then
-	tag=`printf '%s' "$hgid" | cut -d' ' -f2`
+		# Are there uncommitted changes?
+		# These are represented by + after the changeset id.
+		case "$hgid" in
+			*+|*+\ *) printf '%s' -dirty ;;
+		esac
 
-	# Do we have an untagged version?
-	if [ -z "$tag" -o "$tag" = tip ]; then
-		id=`printf '%s' "$hgid" | sed 's/[+ ].*//'`
-		printf '%s%s' -hg "$id"
+		# All done with mercurial
+		return
 	fi
 
-	# Are there uncommitted changes?
-	# These are represented by + after the changeset id.
-	case "$hgid" in
-		*+|*+\ *) printf '%s' -dirty ;;
-	esac
+	# Check for svn and a svn repo.
+	if rev=`svn info 2>/dev/null | grep '^Last Changed Rev'`; then
+		rev=`echo $rev | awk '{print $NF}'`
+		printf -- '-svn%s' "$rev"
 
-	# All done with mercurial
+		# All done with svn
+		return
+	fi
+}
+
+collect_files()
+{
+	local file res
+
+	for file; do
+		case "$file" in
+		*\~*)
+			continue
+			;;
+		esac
+		if test -e "$file"; then
+			res="$res$(cat "$file")"
+		fi
+	done
+	echo "$res"
+}
+
+if $scm_only; then
+	scm_version
 	exit
 fi
 
-# Check for svn and a svn repo.
-if rev=`svn info 2>/dev/null | grep '^Last Changed Rev'`; then
-	rev=`echo $rev | awk '{print $NF}'`
-	printf -- '-svn%s' "$rev"
+if test -e include/config/auto.conf; then
+	source "$_"
+else
+	echo "Error: kernelrelease not valid - run 'make prepare' to update it"
+	exit 1
+fi
 
-	# All done with svn
-	exit
+# localversion* files in the build and source directory
+res="$(collect_files localversion*)"
+if test ! "$srctree" -ef .; then
+	res="$res$(collect_files "$srctree"/localversion*)"
+fi
+
+# CONFIG_LOCALVERSION and LOCALVERSION (if set)
+res="${res}${CONFIG_LOCALVERSION}${LOCALVERSION}"
+
+# scm version string if not at a tagged commit
+if test "$CONFIG_LOCALVERSION_AUTO" = "y"; then
+	# full scm version string
+	res="$res$(scm_version)"
+else
+	# apped a plus sign if the repository is not in a clean tagged
+	# state and  LOCALVERSION= is not specified
+	if test "${LOCALVERSION+set}" != "set"; then
+		scm=$(scm_version --short)
+		res="$res${scm:++}"
+	fi
 fi
+
+echo "$res"
-- 
1.7.1

