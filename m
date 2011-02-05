Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BEUIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:08:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48635 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1BEUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=aP/lnD2PoCa76PgmHUwMlIKjmL/WRffbjO9cY45x1rIUS0kDWsqfvAaPFVHQxJCnZr
         SUotCupnVTQS7sNzhtQFrBrBLuQNhhv5mf+52fTpVkg3ipuyL2HVsaneZAtuPmA5yRKi
         qIxPDc8c5Wm3G/I0iOVYR/jevc5yYDXkWidq0=
Date: Sat, 5 Feb 2011 21:08:28 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: zippel@linux-m68k.org, mmarek@suse.cz, rdunlap@xenotime.net,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v2] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110205200825.GA14400@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
	rdunlap@xenotime.net, akpm@linux-foundation.org,
	andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch builds on https://lkml.org/lkml/2011/2/1/439 . A compound patch
(original patch + all fixes) is available at
http://dl.dropbox.com/u/10406197/kconfiglib.patch (apply with 'git am').

Changelog:
v2:
	- Now supports alternative output directories (O=).
	- $-references were expanded as environment variables in some
	  contexts ('source', 'mainmenu', and 'defconfig') where they should
	  have been expanded as symbol values - fixed. The reason this broke
	  so little is that all symbols whose value come from an environment
	  variable are currently called the same thing as that variable.
	- Added the internal special symbol UNAME_RELEASE, used by
	  DEFCONFIG_LIST. Previously get_defconfig_filename() failed to find
	  .configs whose DEFCONFIG_LIST entry involved UNAME_RELEASE - now
	  works.
	- get_defconfig_filename() now searches relative to $srctree before
	  looking in the current directory, just like the C implementation.
	- Updated example 1 to work regardless of build directory.
	- Precompiled a few regexes.

Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
---
Convenience links:

Compound patch (original + fixes):
http://dl.dropbox.com/u/10406197/kconfiglib.patch

Latest documentation (generated with pydoc -w kconfiglib):
http://dl.dropbox.com/u/10406197/kconfiglib.html

Latest example files (ex1.py updated in v2):
http://dl.dropbox.com/u/10406197/kconfiglib-examples.tar.gz

 scripts/kconfig/Makefile       |   16 ++++---
 scripts/kconfig/kconfiglib.py  |  105 ++++++++++++++++++++++++++++++----------
 scripts/kconfig/kconfigtest.py |    2 +-
 3 files changed, 90 insertions(+), 33 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index cfffe87..0044933 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -41,19 +41,21 @@ scriptconfig:
 	$(Q)if [ ! -n "$(SCRIPT)" ]; then                                                                     \
 			echo 'No script argument provided; use "make scriptconfig SCRIPT=<path to script>".'; \
 	else                                                                                                  \
-			PYTHONPATH="$(obj):$$PYTHONPATH" "$(PYTHONCMD)" "$(SCRIPT)" "$(Kconfig)";             \
+			PYTHONPATH="$(srctree)/$(src):$$PYTHONPATH"                                           \
+			  "$(PYTHONCMD)" "$(SCRIPT)" $(srctree)/$(Kconfig);                                   \
 	fi
 
 iscriptconfig:
-	$(Q)PYTHONPATH="$(obj):$$PYTHONPATH" "$(PYTHONCMD)" -i -c \
-	"import kconfiglib; \
-	 import sys; \
-	 c = kconfiglib.Config(sys.argv[1]); \
-	 print \"A Config instance 'c' for the architecture ({0}) has been created.\".format(c.get_arch())" "$(Kconfig)"
+	$(Q)PYTHONPATH="$(srctree)/$(src):$$PYTHONPATH" "$(PYTHONCMD)" -i -c \
+	  "import kconfiglib; \
+	   import sys; \
+	   c = kconfiglib.Config(sys.argv[1]); \
+	   print \"A Config instance 'c' for the architecture ({0}) has been created.\".format(c.get_arch())" \
+	  $(srctree)/$(Kconfig)
 
 # Used by kconfigtest.py to prevent an 'option defconfig' .config from being loaded
 kconfiglibtestconfig: $(obj)/conf
-	$(Q)$< --defconfig=.config $(Kconfig)
+	$(Q)$< --defconfig=.config $(srctree)/$(Kconfig)
 
 # if no path is given, then use src directory to find file
 ifdef LSMOD
diff --git a/scripts/kconfig/kconfiglib.py b/scripts/kconfig/kconfiglib.py
index 84e70c3..fa3d5ee 100644
--- a/scripts/kconfig/kconfiglib.py
+++ b/scripts/kconfig/kconfiglib.py
@@ -74,8 +74,11 @@ import sys
 # these can be created -- the library has no global state).
 conf = kconfiglib.Config(sys.argv[1])
 
-# Load values from a .config file.
-conf.load_config("arch/x86/configs/i386_defconfig")
+# Load values from a .config file. 'srctree' is an environment variable set by
+# the Linux makefiles to the top-level directory of the kernel tree. It needs
+# to be used here for the script to work with alternative build directories
+# (specified e.g. with O=).
+conf.load_config("$srctree/arch/x86/configs/i386_defconfig")
 
 # Print some information about a symbol (the Config class implements
 # __getitem__() to provide a handy syntax for getting symbols).
@@ -415,7 +418,7 @@ class Config():
 
     def __init__(self,
                  filename = "Kconfig",
-                 base_dir = ".",
+                 base_dir = "$srctree",
                  print_warnings = True,
                  print_undef_assign = False):
         """Creates a new Config object, representing a Kconfig configuration.
@@ -429,9 +432,15 @@ class Config():
                  kconfiglib via 'make scriptconfig' the filename of the
                  correct Kconfig will be in sys.argv[1].
 
-        base_dir (default: ".") -- The base directory relative to which
-                'source' statements within Kconfig files will work. For Linux
-                this should be the top-level directory of the kernel tree.
+        base_dir (default: "$srctree") -- The base directory relative to which
+                'source' statements within Kconfig files will work. For the
+                Linux kernel this should be the top-level directory of the
+                kernel tree. $-references to environment variables will be
+                expanded.
+
+                The environment variable 'srctree' is set by the Linux makefiles
+                to the top-level kernel directory. A default of "." would not
+                work if an alternative build directory is used.
 
         print_warnings (default: True) -- Set to True if warnings related to
                        this configuration should be printed to stderr. This can
@@ -473,6 +482,9 @@ class Config():
         register_special_symbol(TRISTATE, "m", "m")
         register_special_symbol(TRISTATE, "y", "y")
 
+        # DEFCONFIG_LIST uses this
+        register_special_symbol(STRING, "UNAME_RELEASE", os.uname()[2])
+
         self.m = self.syms["m"]
 
         # Maps a symbol to its directly dependent symbols (any symbol whose
@@ -487,8 +499,13 @@ class Config():
         # See Symbol.get_arch()
         self.arch = os.environ.get("ARCH")
 
+        # See Config.__init__(). We need this for get_defconfig_filename().
+        self.srctree = os.environ.get("srctree")
+        if self.srctree is None:
+            self.srctree = "."
+
         self.filename = filename
-        self.base_dir = _strip_trailing_slash(base_dir)
+        self.base_dir = _strip_trailing_slash(os.path.expandvars(base_dir))
 
         # The 'mainmenu' text
         self.mainmenu_text = None
@@ -532,7 +549,11 @@ class Config():
     def load_config(self, filename, reset = True):
         """Loads symbol values from a file in the familiar .config format.
 
-           filename -- The .config file to load.
+           filename -- The .config file to load. $-references to environment
+                       variables will be expanded. For scripts to work even
+                       when an alternative build directory is used with the
+                       Linux kernel, you need to refer to the top-level kernel
+                       directory with "$srctree".
 
            reset (default: True) -- True if the configuration should replace
                  the old configuration; False if it should add to it."""
@@ -544,6 +565,8 @@ class Config():
                        filename,
                        linenr)
 
+        filename = os.path.expandvars(filename)
+
         # Put this first so that a missing file doesn't screw up our state
         line_feeder = _FileFeed(_get_lines(filename), filename)
 
@@ -563,7 +586,7 @@ class Config():
 
         def is_header_line(line):
             return line.startswith("#") and \
-                   not re.match(unset_re, line)
+                   not unset_re.match(line)
 
         first_line = line_feeder.get_next()
 
@@ -605,7 +628,7 @@ class Config():
 
             line = line.strip()
 
-            set_re_match = re.match(set_re, line)
+            set_re_match = set_re.match(line)
             if set_re_match:
                 name, val = set_re_match.groups()
                 val = _strip_quotes(val, line, filename, linenr)
@@ -635,7 +658,7 @@ class Config():
                                        linenr)
                 continue
 
-            unset_re_match = re.match(unset_re, line)
+            unset_re_match = unset_re.match(line)
             if unset_re_match:
                 name = unset_re_match.group(1)
                 if name in self.syms:
@@ -688,15 +711,20 @@ class Config():
         """Returns the text of the 'mainmenu' statement (with environment
         variables expanded to the value they had when the Config was created),
         or None if the configuration has no 'mainmenu' statement."""
-        return self.mainmenu_text
+        return self._expand_sym_refs(self.mainmenu_text)
 
     def get_defconfig_filename(self):
-        """Returns the name of the defconfig file, which is the first
-        existing file in the list given in a symbol having 'option
-        defconfig_list' set. $-references to environment variables will be
-        expanded. Returns None in case of no defconfig file. Setting 'option
-        defconfig_list' on multiple symbols currently results in undefined
-        behavior."""
+        """Returns the name of the defconfig file, which is the first existing
+        file in the list given in a symbol having 'option defconfig_list' set.
+        $-references to symbols will be expanded ("$FOO bar" -> "foo bar" if
+        FOO has the value "foo"). Returns None in case of no defconfig file.
+        Setting 'option defconfig_list' on multiple symbols currently results
+        in undefined behavior.
+
+        If the environment variable 'srctree' was set when the Config was
+        created, get_defconfig_filename() will first look relative to that
+        directory before looking in the current directory. See
+        Config.__init__()."""
 
         if self.defconfig_sym is None:
             return None
@@ -704,9 +732,16 @@ class Config():
         for (filename, cond_expr) in self.defconfig_sym.def_exprs:
             cond_val = self._eval_expr(cond_expr)
             if cond_val == "y":
-                f = os.path.expandvars(filename)
-                if os.path.exists(f):
-                    return f
+                filename = self._expand_sym_refs(filename)
+
+                # We first look in $srctree. os.path.join() won't work here as
+                # an absolute path in filename would override $srctree.
+                srctree_filename = os.path.normpath(self.srctree + "/" + filename)
+                if os.path.exists(srctree_filename):
+                    return srctree_filename
+
+                if os.path.exists(filename):
+                    return filename
 
         return None
 
@@ -1295,7 +1330,7 @@ class Config():
 
             elif t0 == T_SOURCE:
                 kconfig_file = tokens.get_next()
-                f = os.path.join(self.base_dir, os.path.expandvars(kconfig_file))
+                f = os.path.join(self.base_dir, self._expand_sym_refs(kconfig_file))
 
                 if not os.path.exists(f):
                     raise IOError, ('{0}:{1}: sourced file "{2}" not found. Perhaps '
@@ -1319,7 +1354,7 @@ class Config():
                                filename,
                                linenr)
 
-                self.mainmenu_text = os.path.expandvars(text)
+                self.mainmenu_text = text
 
             else:
                 _parse_error(line, "unrecognized construct.", filename, linenr)
@@ -1896,6 +1931,23 @@ might be an error, and you should e-mail kconfiglib@gmail.com.
 
         return "{0} (value: {1})".format(_expr_to_str(expr), _expr_to_str(val))
 
+    def _expand_sym_refs(self, s):
+        """Expands $-references to symbols in 's' to symbol values, or to the
+        empty string for undefined symbols."""
+
+        while True:
+            sym_ref_re_match = sym_ref_re.search(s)
+            if sym_ref_re_match is None:
+                return s
+
+            sym_name = sym_ref_re_match.group(0)[1:]
+            sym = self.syms.get(sym_name)
+            expansion = "" if sym is None else sym.calc_value()
+
+            s = s[:sym_ref_re_match.start()] + \
+                expansion + \
+                s[sym_ref_re_match.end():]
+
     def _get_sym_or_choice_str(self, sc):
         """Symbols and choices have many properties in common, so we factor out
         common __str__() stuff here. "sc" is short for "symbol or choice"."""
@@ -2246,8 +2298,11 @@ string_lex = (T_BOOL, T_TRISTATE, T_INT, T_HEX, T_STRING,
 sym_chars = frozenset(string.ascii_letters + string.digits + "._/-")
 
 # Regular expressions for parsing .config files
-set_re   = r"CONFIG_(\w+)=(.*)"
-unset_re = r"# CONFIG_(\w+) is not set"
+set_re   = re.compile(r"CONFIG_(\w+)=(.*)")
+unset_re = re.compile(r"# CONFIG_(\w+) is not set")
+
+# Regular expression for finding $-references to symbols in strings
+sym_ref_re = re.compile(r"\$[A-Za-z_]+")
 
 # Integers representing symbol types
 UNKNOWN, BOOL, TRISTATE, STRING, HEX, INT = range(0, 6)
diff --git a/scripts/kconfig/kconfigtest.py b/scripts/kconfig/kconfigtest.py
index 9d27dca..e6961a4 100644
--- a/scripts/kconfig/kconfigtest.py
+++ b/scripts/kconfig/kconfigtest.py
@@ -81,7 +81,7 @@ def get_arch_configs():
     def add_arch(ARCH, res):
         os.environ["SRCARCH"] = archdir
         os.environ["ARCH"] = ARCH
-        res.append(kconfiglib.Config())
+        res.append(kconfiglib.Config(base_dir = "."))
 
     res = []
 
-- 
1.7.0.4

