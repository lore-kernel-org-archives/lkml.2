Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0ISBe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 21:34:27 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:45263 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754861Ab0ISBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 21:34:26 -0400
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] Documentation/kbuild: major edit of modules.txt sections 1-4
Date: Sat, 18 Sep 2010 18:33:57 -0700
Message-Id: <1284860037-24033-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Omit needless words and sentences; reorganize and tighten sentence structure;
swap sections 2.2 and 2.3 for a more logical flow; remove section 3, therefore
shifting 4->3; add to explanations; and add section on building multiple modules.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---

Since the changes I was making were significant, I decided to go ahead and do a
thorough edit of the first 4 sections. An explanation of building single object
files is still needed in section 2.4. And I plan to edit the rest of the file,
although I don't anticipate as much change.

 Documentation/kbuild/modules.txt |  387 +++++++++++++++++++-------------------
 1 files changed, 189 insertions(+), 198 deletions(-)

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 0767cf6..799b683 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -1,215 +1,185 @@
+Building External Modules
 
-In this document you will find information about:
-- how to build external modules
-- how to make your module use the kbuild infrastructure
-- how kbuild will install a kernel
-- how to install modules in a non-standard location
+This document describes how-to build an out-of-tree kernel module.
 
 === Table of Contents
 
 	=== 1 Introduction
-	=== 2 How to build external modules
-	   --- 2.1 Building external modules
-	   --- 2.2 Available targets
-	   --- 2.3 Available options
-	   --- 2.4 Preparing the kernel tree for module build
-	   --- 2.5 Building separate files for a module
-	=== 3. Example commands
-	=== 4. Creating a kbuild file for an external module
-	=== 5. Include files
-	   --- 5.1 How to include files from the kernel include dir
-	   --- 5.2 External modules using an include/ dir
-	   --- 5.3 External modules using several directories
-	=== 6. Module installation
-	   --- 6.1 INSTALL_MOD_PATH
-	   --- 6.2 INSTALL_MOD_DIR
-	=== 7. Module versioning & Module.symvers
-	   --- 7.1 Symbols from the kernel (vmlinux + modules)
-	   --- 7.2 Symbols and external modules
-	   --- 7.3 Symbols from another external module
-	=== 8. Tips & Tricks
-	   --- 8.1 Testing for CONFIG_FOO_BAR
+	=== 2 How-to Build External Modules
+	   --- 2.1 Command Syntax
+	   --- 2.2 Options
+	   --- 2.3 Targets
+	   --- 2.4 Building Separate Files
+	=== 3. Creating a Kbuild File for an External Module
+	   --- 3.1 Shared Makefile
+	   --- 3.2 Separate Kbuild file and Makefile
+	   --- 3.3 Binary Blobs
+	   --- 3.4 Building Multiple Modules
+	=== 4. Include files
+	   --- 4.1 How to include files from the kernel include dir
+	   --- 4.2 External modules using an include/ dir
+	   --- 4.3 External modules using several directories
+	=== 5. Module installation
+	   --- 5.1 INSTALL_MOD_PATH
+	   --- 5.2 INSTALL_MOD_DIR
+	=== 6. Module versioning & Module.symvers
+	   --- 6.1 Symbols from the kernel (vmlinux + modules)
+	   --- 6.2 Symbols and external modules
+	   --- 6.3 Symbols from another external module
+	=== 7. Tips & Tricks
+	   --- 7.1 Testing for CONFIG_FOO_BAR
 
 
 
 === 1. Introduction
 
-kbuild includes functionality for building modules both
-within the kernel source tree and outside the kernel source tree.
-The latter is usually referred to as external or "out-of-tree"
-modules and is used both during development and for modules that
-are not planned to be included in the kernel tree.
+"kbuild" is the build system used by the Linux kernel. Modules must use
+kbuild to stay compatible with changes in the build infrastructure and
+to pick up the right flags to "gcc." Functionality for building modules
+both in-tree and out-of-tree is provided. The method for building
+either is similar, and all modules are initially developed and built
+out-of-tree.
 
-What is covered within this file is mainly information to authors
-of modules. The author of an external module should supply
-a makefile that hides most of the complexity, so one only has to type
-'make' to build the module. A complete example will be presented in
-chapter 4, "Creating a kbuild file for an external module".
+Covered in this document is information aimed at developers interested
+in building out-of-tree (or "external") modules. The author of an
+external module should supply a makefile that hides most of the
+complexity, so one only has to type "make" to build the module. This is
+easily accomplished, and a complete example will be presented in
+section 3.
 
 
-=== 2. How to build external modules
+=== 2. How-to Build External Modules
 
-kbuild offers functionality to build external modules, with the
-prerequisite that there is a pre-built kernel available with full source.
-A subset of the targets available when building the kernel is available
-when building an external module.
+To build external modules, you must have a pre-built kernel available
+that contains the configuration and header files used in the build.
+Also, the kernel must have been built with modules enabled. If you are
+using a distribution kernel, there will be a package for the kernel you
+are running provided by your distribution.
 
---- 2.1 Building external modules
+An alternative is to use the "make" target "modules_prepare." This will
+make sure the kernel contains the information required. The target
+exists solely as a simple way to prepare a kernel source tree for
+building external modules.
 
-	Use the following command to build an external module:
+NOTE: "modules_prepare" will not build Module.symvers even if
+CONFIG_MODVERSIONS is set; therefore, a full kernel build needs to be
+executed to make module versioning work.
 
-		make -C <path-to-kernel> M=`pwd`
+--- 2.1 Command Syntax
 
-	For the running kernel use:
+	The command to build an external module is:
 
-		make -C /lib/modules/`uname -r`/build M=`pwd`
+		make -C <path_to_kernel_src> M=$PWD
 
-	For the above command to succeed, the kernel must have been
-	built with modules enabled.
+	The kbuild system knows that an external module is being built
+	due to the "M=<dir>" option given in the command.
 
-	To install the modules that were just built:
+	To build against the running kernel use:
 
-		make -C <path-to-kernel> M=`pwd` modules_install
+		make -C /lib/modules/`uname -r`/build M=$PWD
 
-	More complex examples will be shown later, the above should
-	be enough to get you started.
+	Then to install the module(s) just built, add the target
+	"modules_install" to the command:
 
---- 2.2 Available targets
+		make -C /lib/modules/`uname -r`/build M=$PWD modules_install
 
-	$KDIR refers to the path to the kernel source top-level directory
+--- 2.2 Options
 
-	make -C $KDIR M=`pwd`
-		Will build the module(s) located in current directory.
-		All output files will be located in the same directory
-		as the module source.
-		No attempts are made to update the kernel source, and it is
-		a precondition that a successful make has been executed
-		for the kernel.
+	($KDIR refers to the path of the kernel source directory.)
 
-	make -C $KDIR M=`pwd` modules
-		The modules target is implied when no target is given.
-		Same functionality as if no target was specified.
-		See description above.
+	make -C $KDIR M=$PWD
 
-	make -C $KDIR M=`pwd` modules_install
-		Install the external module(s).
-		Installation default is in /lib/modules/<kernel-version>/extra,
-		but may be prefixed with INSTALL_MOD_PATH - see separate
-		chapter.
+	-C $KDIR
+		The directory where the kernel source is located.
+		"make" will actually change to the specified directory
+		when executing and will change back when finished.
 
-	make -C $KDIR M=`pwd` clean
-		Remove all generated files for the module - the kernel
-		source directory is not modified.
+	M=$PWD
+		Informs kbuild that an external module is being built.
+		The value given to "M" is the absolute path of the
+		directory where the external module (kbuild file) is
+		located.
 
-	make -C $KDIR M=`pwd` help
-		help will list the available target when building external
-		modules.
+--- 2.3 Targets
 
---- 2.3 Available options:
+	When building an external module, only a subset of the "make"
+	targets are available.
 
-	$KDIR refers to the path to the kernel source top-level directory
+	make -C $KDIR M=$PWD [target]
 
-	make -C $KDIR
-		Used to specify where to find the kernel source.
-		'$KDIR' represent the directory where the kernel source is.
-		Make will actually change directory to the specified directory
-		when executed but change back when finished.
+	The default will build the module(s) located in the current
+	directory, so a target does not need to be specified. All
+	output files will also be generated in this directory. No
+	attempts are made to update the kernel source, and it is a
+	precondition that a successful "make" has been executed for the
+	kernel.
 
-	make -C $KDIR M=`pwd`
-		M= is used to tell kbuild that an external module is
-		being built.
-		The option given to M= is the directory where the external
-		module (kbuild file) is located.
-		When an external module is being built only a subset of the
-		usual targets are available.
+	modules
+		The default target for external modules. It has the
+		same functionality as if no target was specified. See
+		description above.
 
-	make -C $KDIR SUBDIRS=`pwd`
-		Same as M=. The SUBDIRS= syntax is kept for backwards
-		compatibility.
+	modules_install
+		Install the external module(s). The default location is
+		/lib/modules/<kernel_release>/extra, but a prefix may
+		be added with INSTALL_MOD_PATH (discussed in section 5).
 
---- 2.4 Preparing the kernel tree for module build
+	clean
+		Remove all generated files in the module directory only.
 
-	To make sure the kernel contains the information required to
-	build external modules the target 'modules_prepare' must be used.
-	'modules_prepare' exists solely as a simple way to prepare
-	a kernel source tree for building external modules.
-	Note: modules_prepare will not build Module.symvers even if
-	CONFIG_MODVERSIONS is set. Therefore a full kernel build
-	needs to be executed to make module versioning work.
+	help
+		List the available targets for external modules.
 
---- 2.5 Building separate files for a module
-	It is possible to build single files which are part of a module.
-	This works equally well for the kernel, a module and even for
-	external modules.
-	Examples (module foo.ko, consist of bar.o, baz.o):
-		make -C $KDIR M=`pwd` bar.lst
-		make -C $KDIR M=`pwd` bar.o
-		make -C $KDIR M=`pwd` foo.ko
-		make -C $KDIR M=`pwd` /
-
-
-=== 3. Example commands
-
-This example shows the actual commands to be executed when building
-an external module for the currently running kernel.
-In the example below, the distribution is supposed to use the
-facility to locate output files for a kernel compile in a different
-directory than the kernel source - but the examples will also work
-when the source and the output files are mixed in the same directory.
-
-# Kernel source
-/lib/modules/<kernel-version>/source -> /usr/src/linux-<version>
+--- 2.4 Building Separate Files
 
-# Output from kernel compile
-/lib/modules/<kernel-version>/build -> /usr/src/linux-<version>-up
-
-Change to the directory where the kbuild file is located and execute
-the following commands to build the module:
+	It is possible to build single files that are part of a module.
+	This works equally well for the kernel, a module, and even for
+	external modules.
 
-	cd /home/user/src/module
-	make -C /usr/src/`uname -r`/source            \
-	        O=/lib/modules/`uname-r`/build        \
-	        M=`pwd`
+	Example (The module foo.ko, consist of bar.o and baz.o):
+		make -C $KDIR M=$PWD bar.lst
+		make -C $KDIR M=$PWD baz.o
+		make -C $KDIR M=$PWD foo.ko
+		make -C $KDIR M=$PWD /
 
-Then, to install the module use the following command:
 
-	make -C /usr/src/`uname -r`/source            \
-	        O=/lib/modules/`uname-r`/build        \
-	        M=`pwd`                               \
-		modules_install
+=== 3. Creating a Kbuild File for an External Module
 
-If you look closely you will see that this is the same command as
-listed before - with the directories spelled out.
+In the last section we saw the command to build a module for the
+running kernel. The module is not actually built, however, because a
+build file is required. Contained in this file will be the name of
+the module(s) being built, along with the list of requisite source
+files. The file may be as simple as a single line:
 
-The above are rather long commands, and the following chapter
-lists a few tricks to make it all easier.
+	obj-m := <module_name>.o
 
+The kbuild system will build <module_name>.o from <module_name>.c,
+and, after linking, will result in the kernel module <module_name>.ko.
+The above line can be put in either a "Kbuild" file or a "Makefile."
+When the module is built from multiple sources, an additional line is
+needed listing the files:
 
-=== 4. Creating a kbuild file for an external module
+	<module_name>-y := <src1>.o <src2>.o ...
 
-kbuild is the build system for the kernel, and external modules
-must use kbuild to stay compatible with changes in the build system
-and to pick up the right flags to gcc etc.
+NOTE: Further documentation describing the syntax used by kbuild is
+located in Documentation/kbuild/makefiles.txt.
 
-The kbuild file used as input shall follow the syntax described
-in Documentation/kbuild/makefiles.txt. This chapter will introduce a few
-more tricks to be used when dealing with external modules.
+The examples below demonstrate how-to create a build file for the
+module 8123.ko, which is built from the following files:
 
-In the following a Makefile will be created for a module with the
-following files:
 	8123_if.c
 	8123_if.h
 	8123_pci.c
 	8123_bin.o_shipped	<= Binary blob
 
---- 4.1 Shared Makefile for module and kernel
+--- 3.1 Shared Makefile
 
-	An external module always includes a wrapper Makefile supporting
-	building the module using 'make' with no arguments.
-	The Makefile provided will most likely include additional
-	functionality such as test targets etc. and this part shall
-	be filtered away from kbuild since it may impact kbuild if
-	name clashes occurs.
+	An external module always includes a wrapper makefile that
+	supports building the module using "make" with no arguments.
+	This target is not used by kbuild; it is only for convenience.
+	Additional functionality, such as test targets, can be included
+	but should be filtered out from kbuild due to possible name
+	clashes.
 
 	Example 1:
 		--> filename: Makefile
@@ -219,11 +189,11 @@ following files:
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
 		else
-		# Normal Makefile
+		# normal makefile
+		KDIR ?= /lib/modules/`uname -r`/build
 
-		KERNELDIR := /lib/modules/`uname -r`/build
-		all::
-			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
+		default:
+			$(MAKE) -C $(KDIR) M=$$PWD
 
 		# Module specific targets
 		genbin:
@@ -231,15 +201,20 @@ following files:
 
 		endif
 
-	In example 1, the check for KERNELRELEASE is used to separate
-	the two parts of the Makefile. kbuild will only see the two
-	assignments whereas make will see everything except the two
-	kbuild assignments.
+	The check for KERNELRELEASE is used to separate the two parts
+	of the makefile. In the example, kbuild will only see the two
+	assignments, whereas "make" will see everything except these
+	two assignments. This is due to two passes made on the file:
+	the first pass is by the "make" instance run on the
+	command line; the second pass is by the kbuild system, which is
+	initiated by the parameterized "make" in the default target.
 
-	In recent versions of the kernel, kbuild will look for a file named
-	Kbuild and as second option look for a file named Makefile.
-	Utilising the Kbuild file makes us split up the Makefile in example 1
-	into two files as shown in example 2:
+--- 3.2 Separate Kbuild File and Makefile
+
+	In newer versions of the kernel, kbuild will first look for a
+	file named "Kbuild", and only if that is not found, will it
+	then look for a makefile. Utilizing a "Kbuild" file allows us
+	to split up the makefile from example 1 into two files:
 
 	Example 2:
 		--> filename: Kbuild
@@ -247,20 +222,21 @@ following files:
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
 		--> filename: Makefile
-		KERNELDIR := /lib/modules/`uname -r`/build
-		all::
-			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
+		KDIR ?= /lib/modules/`uname -r`/build
+
+		default:
+			$(MAKE) -C $(KDIR) M=$$PWD
 
 		# Module specific targets
 		genbin:
 			echo "X" > 8123_bin.o_shipped
 
+	The split in example 2 is questionable due to the simplicity of
+	each file; however, some external modules use makefiles
+	consisting of several hundred lines, and here it really pays
+	off to separate the kbuild part from the rest.
 
-	In example 2, we are down to two fairly simple files and for simple
-	files as used in this example the split is questionable. But some
-	external modules use Makefiles of several hundred lines and here it
-	really pays off to separate the kbuild part from the rest.
-	Example 3 shows a backward compatible version.
+	The next example shows a backward compatible version.
 
 	Example 3:
 		--> filename: Kbuild
@@ -269,13 +245,15 @@ following files:
 
 		--> filename: Makefile
 		ifneq ($(KERNELRELEASE),)
+		# kbuild part of makefile
 		include Kbuild
+
 		else
-		# Normal Makefile
+		# normal makefile
+		KDIR ?= /lib/modules/`uname -r`/build
 
-		KERNELDIR := /lib/modules/`uname -r`/build
-		all::
-			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
+		default:
+			$(MAKE) -C $(KDIR) M=$$PWD
 
 		# Module specific targets
 		genbin:
@@ -283,28 +261,41 @@ following files:
 
 		endif
 
-	The trick here is to include the Kbuild file from Makefile, so
-	if an older version of kbuild picks up the Makefile, the Kbuild
-	file will be included.
+	Here the "Kbuild" file is included from the makefile. This
+	allows an older version of kbuild, which only knows of
+	makefiles, to be used when the "make" and kbuild parts are
+	split into separate files.
 
---- 4.2 Binary blobs included in a module
+--- 3.3 Binary Blobs
 
-	Some external modules needs to include a .o as a blob. kbuild
-	has support for this, but requires the blob file to be named
-	<filename>_shipped. In our example the blob is named
-	8123_bin.o_shipped and when the kbuild rules kick in the file
-	8123_bin.o is created as a simple copy off the 8213_bin.o_shipped file
-	with the _shipped part stripped of the filename.
-	This allows the 8123_bin.o filename to be used in the assignment to
-	the module.
+	Some external modules need to include an object file as a blob.
+	kbuild has support for this, but requires the blob file to be
+	named <filename>_shipped. When the kbuild rules kick in, a copy
+	of <filename>_shipped is created with _shipped stripped off,
+	giving us <filename>. This shortened filename can be used in
+	the assignment to the module.
+
+	Throughout this section, 8123_bin.o_shipped has been used to
+	build the kernel module 8123.ko; it has been included as
+	8123_bin.o.
 
-	Example 4:
-		obj-m  := 8123.o
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
-	In example 4, there is no distinction between the ordinary .c/.h files
-	and the binary file. But kbuild will pick up different rules to create
-	the .o file.
+	Although there is no distinction between the ordinary source
+	files and the binary file, kbuild will pick up different rules
+	when creating the object file for the module.
+
+--- 3.4 Building Multiple Modules
+
+	kbuild supports building multiple modules with a single build
+	file. For example, if you want to build two modules, foo and
+	bar, the kbuild lines would be:
+
+		obj-m := foo.o bar.o
+		foo-y := <foo_srcs>
+		bar-y := <bar_srcs>
+
+	It is that simple!
 
 
 === 5. Include files
-- 
1.7.2.1

