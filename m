Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0ITGNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 02:13:13 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:57347
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab0ITGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 02:13:11 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2010 02:13:11 EDT
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Documentation/kbuild: major edit of modules.txt sections 5-8
Date: Sun, 19 Sep 2010 23:06:36 -0700
Message-Id: <1284962796-31964-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A follow-up to my edit of the first 4 sections.

Shift sections down by one due to the deletion of section 3; grammar
corrections along with some rewording; margin width cleanup; and
change EXTRA_CFLAGS -> ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---

Should I add a subsection to section 5. discussing MODLIB?

 Documentation/kbuild/modules.txt |  358 +++++++++++++++++++-------------------
 1 files changed, 177 insertions(+), 181 deletions(-)

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 799b683..b572db3 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -15,17 +15,17 @@ This document describes how-to build an out-of-tree kernel module.
 	   --- 3.2 Separate Kbuild file and Makefile
 	   --- 3.3 Binary Blobs
 	   --- 3.4 Building Multiple Modules
-	=== 4. Include files
-	   --- 4.1 How to include files from the kernel include dir
-	   --- 4.2 External modules using an include/ dir
-	   --- 4.3 External modules using several directories
-	=== 5. Module installation
+	=== 4. Include Files
+	   --- 4.1 Kernel Includes
+	   --- 4.2 Single Subdirectory
+	   --- 4.3 Several Subdirectories
+	=== 5. Module Installation
 	   --- 5.1 INSTALL_MOD_PATH
 	   --- 5.2 INSTALL_MOD_DIR
-	=== 6. Module versioning & Module.symvers
-	   --- 6.1 Symbols from the kernel (vmlinux + modules)
-	   --- 6.2 Symbols and external modules
-	   --- 6.3 Symbols from another external module
+	=== 6. Module Versioning
+	   --- 6.1 Symbols From the Kernel (vmlinux + modules)
+	   --- 6.2 Symbols and External Modules
+	   --- 6.3 Symbols From Another External Module
 	=== 7. Tips & Tricks
 	   --- 7.1 Testing for CONFIG_FOO_BAR
 
@@ -298,236 +298,232 @@ module 8123.ko, which is built from the following files:
 	It is that simple!
 
 
-=== 5. Include files
+=== 4. Include Files
 
-Include files are a necessity when a .c file uses something from other .c
-files (not strictly in the sense of C, but if good programming practice is
-used). Any module that consists of more than one .c file will have a .h file
-for one of the .c files.
+Within the kernel, header files are kept in standard locations
+according to the following rule:
 
-- If the .h file only describes a module internal interface, then the .h file
-  shall be placed in the same directory as the .c files.
-- If the .h files describe an interface used by other parts of the kernel
-  located in different directories, the .h files shall be located in
-  include/linux/ or other include/ directories as appropriate.
+	* If the header file only describes the internal interface of a
+	  module, then the file is placed in the same directory as the
+	  source files.
+	* If the header file describes an interface used by other parts
+	  of the kernel that are located in different directories, then
+	  the file is placed in include/linux/.
 
-One exception for this rule is larger subsystems that have their own directory
-under include/ such as include/scsi. Another exception is arch-specific
-.h files which are located under include/asm-$(ARCH)/*.
+	  NOTE: There are two notable exceptions to this rule: larger
+	  subsystems have their own directory under include/, such as
+	  include/scsi; and architecture specific headers are located
+	  under arch/$(ARCH)/include/.
 
-External modules have a tendency to locate include files in a separate include/
-directory and therefore need to deal with this in their kbuild file.
+--- 4.1 Kernel Includes
 
---- 5.1 How to include files from the kernel include dir
-
-	When a module needs to include a file from include/linux/, then one
-	just uses:
+	To include a header file located under include/linux/, simply
+	use:
 
 		#include <linux/modules.h>
 
-	kbuild will make sure to add options to gcc so the relevant
-	directories are searched.
-	Likewise for .h files placed in the same directory as the .c file.
-
-		#include "8123_if.h"
-
-	will do the job.
+	kbuild will add options to "gcc" so the relevant directories
+	are searched.
 
---- 5.2 External modules using an include/ dir
+--- 4.2 Single Subdirectory
 
-	External modules often locate their .h files in a separate include/
-	directory although this is not usual kernel style. When an external
-	module uses an include/ dir then kbuild needs to be told so.
-	The trick here is to use either EXTRA_CFLAGS (take effect for all .c
-	files) or CFLAGS_$F.o (take effect only for a single file).
+	External modules tend to place header files in a separate
+	include/ directory where their source is located, although this
+	is not the usual kernel style. To inform kbuild of the
+	directory use either ccflags-y or CFLAGS_<filename>.o.
 
-	In our example, if we move 8123_if.h to a subdirectory named include/
-	the resulting Kbuild file would look like:
+	Using the example from section 3, if we moved 8123_if.h to a
+	subdirectory named include, the resulting kbuild file would
+	look like:
 
 		--> filename: Kbuild
-		obj-m  := 8123.o
+		obj-m := 8123.o
 
-		EXTRA_CFLAGS := -Iinclude
+		ccflags-y := -Iinclude
 		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
 
-	Note that in the assignment there is no space between -I and the path.
-	This is a kbuild limitation:  there must be no space present.
-
---- 5.3 External modules using several directories
+	Note that in the assignment there is no space between -I and
+	the path. This is a limitation of kbuild: there must be no
+	space present.
 
-	If an external module does not follow the usual kernel style, but
-	decides to spread files over several directories, then kbuild can
-	handle this too.
+--- 4.3 Several Subdirectories
 
+	kbuild can handle files that are spread over several directories.
 	Consider the following example:
 
-	|
-	+- src/complex_main.c
-	|   +- hal/hardwareif.c
-	|   +- hal/include/hardwareif.h
-	+- include/complex.h
-
-	To build a single module named complex.ko, we then need the following
+	.
+	|__ src
+	|   |__ complex_main.c
+	|   |__ hal
+	|	|__ hardwareif.c
+	|	|__ include
+	|	    |__ hardwareif.h
+	|__ include
+	    |__ complex.h
+
+	To build the module complex.ko, we then need the following
 	kbuild file:
 
-	Kbuild:
+		--> filename: Kbuild
 		obj-m := complex.o
 		complex-y := src/complex_main.o
 		complex-y += src/hal/hardwareif.o
 
-		EXTRA_CFLAGS := -I$(src)/include
-		EXTRA_CFLAGS += -I$(src)src/hal/include
+		ccflags-y := -I$(src)/include
+		ccflags-y += -I$(src)/src/hal/include
 
+	As you can see, kbuild knows how to handle object files located
+	in other directories. The trick is to specify the directory
+	relative to the kbuild file's location. That being said, this
+	is NOT recommended practice.
 
-	kbuild knows how to handle .o files located in another directory -
-	although this is NOT recommended practice. The syntax is to specify
-	the directory relative to the directory where the Kbuild file is
-	located.
+	For the header files, kbuild must be explicitly told where to
+	look. When kbuild executes, the current directory is always the
+	root of the kernel tree (the argument to "-C") and therefore an
+	absolute path is needed. $(src) provides the absolute path by
+	pointing to the directory where the currently executing kbuild
+	file is located.
 
-	To find the .h files, we have to explicitly tell kbuild where to look
-	for the .h files. When kbuild executes, the current directory is always
-	the root of the kernel tree (argument to -C) and therefore we have to
-	tell kbuild how to find the .h files using absolute paths.
-	$(src) will specify the absolute path to the directory where the
-	Kbuild file are located when being build as an external module.
-	Therefore -I$(src)/ is used to point out the directory of the Kbuild
-	file and any additional path are just appended.
 
-=== 6. Module installation
+=== 5. Module Installation
 
-Modules which are included in the kernel are installed in the directory:
+Modules which are included in the kernel are installed in the
+directory:
 
 	/lib/modules/$(KERNELRELEASE)/kernel
 
-External modules are installed in the directory:
+And external modules are installed in:
 
 	/lib/modules/$(KERNELRELEASE)/extra
 
---- 6.1 INSTALL_MOD_PATH
+--- 5.1 INSTALL_MOD_PATH
 
-	Above are the default directories, but as always, some level of
-	customization is possible. One can prefix the path using the variable
-	INSTALL_MOD_PATH:
+	Above are the default directories but as always some level of
+	customization is possible. A prefix can be added to the
+	installation path using the variable INSTALL_MOD_PATH:
 
 		$ make INSTALL_MOD_PATH=/frodo modules_install
 		=> Install dir: /frodo/lib/modules/$(KERNELRELEASE)/kernel
 
-	INSTALL_MOD_PATH may be set as an ordinary shell variable or as in the
-	example above, can be specified on the command line when calling make.
-	INSTALL_MOD_PATH has effect both when installing modules included in
-	the kernel as well as when installing external modules.
+	INSTALL_MOD_PATH may be set as an ordinary shell variable or,
+	as shown above, can be specified on the command line when
+	calling "make." This has effect when installing both in-tree
+	and out-of-tree modules.
 
---- 6.2 INSTALL_MOD_DIR
+--- 5.2 INSTALL_MOD_DIR
 
-	When installing external modules they are by default installed to a
-	directory under /lib/modules/$(KERNELRELEASE)/extra, but one may wish
-	to locate modules for a specific functionality in a separate
-	directory. For this purpose, one can use INSTALL_MOD_DIR to specify an
-	alternative name to 'extra'.
+	External modules are by default installed to a directory under
+	/lib/modules/$(KERNELRELEASE)/extra, but you may wish to locate
+	modules for a specific functionality in a separate directory.
+	For this purpose, use INSTALL_MOD_DIR to specify an alternative
+	name to "extra."
 
-		$ make INSTALL_MOD_DIR=gandalf -C KERNELDIR \
-			M=`pwd` modules_install
+		$ make INSTALL_MOD_DIR=gandalf -C $KDIR \
+		       M=$PWD modules_install
 		=> Install dir: /lib/modules/$(KERNELRELEASE)/gandalf
 
 
-=== 7. Module versioning & Module.symvers
+=== 6. Module Versioning
 
-Module versioning is enabled by the CONFIG_MODVERSIONS tag.
+Module versioning is enabled by the CONFIG_MODVERSIONS tag, and is used
+as a simple ABI consistency check. A CRC value of the full prototype
+for an exported symbol is created. When a module is loaded/used, the
+CRC values contained in the kernel are compared with similar values in
+the module; if they are not equal, the kernel refuses to load the
+module.
 
-Module versioning is used as a simple ABI consistency check. The Module
-versioning creates a CRC value of the full prototype for an exported symbol and
-when a module is loaded/used then the CRC values contained in the kernel are
-compared with similar values in the module. If they are not equal, then the
-kernel refuses to load the module.
+Module.symvers contains a list of all exported symbols from a kernel
+build.
 
-Module.symvers contains a list of all exported symbols from a kernel build.
+--- 6.1 Symbols From the Kernel (vmlinux + modules)
 
---- 7.1 Symbols from the kernel (vmlinux + modules)
-
-	During a kernel build, a file named Module.symvers will be generated.
-	Module.symvers contains all exported symbols from the kernel and
-	compiled modules. For each symbols, the corresponding CRC value
-	is stored too.
+	During a kernel build, a file named Module.symvers will be
+	generated. Module.symvers contains all exported symbols from
+	the kernel and compiled modules. For each symbol, the
+	corresponding CRC value is also stored.
 
 	The syntax of the Module.symvers file is:
-		<CRC>       <Symbol>           <module>
-	Sample:
+		<CRC>	    <Symbol>	       <module>
+
 		0x2d036834  scsi_remove_host   drivers/scsi/scsi_mod
 
-	For a kernel build without CONFIG_MODVERSIONS enabled, the crc
-	would read: 0x00000000
+	For a kernel build without CONFIG_MODVERSIONS enabled, the CRC
+	would read 0x00000000.
 
 	Module.symvers serves two purposes:
-	1) It lists all exported symbols both from vmlinux and all modules
-	2) It lists the CRC if CONFIG_MODVERSIONS is enabled
-
---- 7.2 Symbols and external modules
-
-	When building an external module, the build system needs access to
-	the symbols from the kernel to check if all external symbols are
-	defined. This is done in the MODPOST step and to obtain all
-	symbols, modpost reads Module.symvers from the kernel.
-	If a Module.symvers file is present in the directory where
-	the external module is being built, this file will be read too.
-	During the MODPOST step, a new Module.symvers file will be written
-	containing all exported symbols that were not defined in the kernel.
-
---- 7.3 Symbols from another external module
-
-	Sometimes, an external module uses exported symbols from another
-	external module. Kbuild needs to have full knowledge on all symbols
-	to avoid spitting out warnings about undefined symbols.
-	Three solutions exist to let kbuild know all symbols of more than
-	one external module.
-	The method with a top-level kbuild file is recommended but may be
-	impractical in certain situations.
-
-	Use a top-level Kbuild file
-		If you have two modules: 'foo' and 'bar', and 'foo' needs
-		symbols from 'bar', then one can use a common top-level kbuild
-		file so both modules are compiled in same build.
-
-		Consider following directory layout:
-		./foo/ <= contains the foo module
-		./bar/ <= contains the bar module
-		The top-level Kbuild file would then look like:
-
-		#./Kbuild: (this file may also be named Makefile)
+	1) It lists all exported symbols from vmlinux and all modules.
+	2) It lists the CRC if CONFIG_MODVERSIONS is enabled.
+
+--- 6.2 Symbols and External Modules
+
+	When building an external module, the build system needs access
+	to the symbols from the kernel to check if all external symbols
+	are defined. This is done in the MODPOST step. modpost obtains
+	the symbols by reading Module.symvers from the kernel source
+	tree. If a Module.symvers file is present in the directory
+	where the external module is being built, this file will be
+	read too. During the MODPOST step, a new Module.symvers file
+	will be written containing all exported symbols that were not
+	defined in the kernel.
+
+--- 6.3 Symbols From Another External Module
+
+	Sometimes, an external module uses exported symbols from
+	another external module. kbuild needs to have full knowledge of
+	all symbols to avoid spitting out warnings about undefined
+	symbols. Three solutions exist for this situation.
+
+	NOTE: The method with a top-level kbuild file is recommended
+	but may be impractical in certain situations.
+
+	Use a top-level kbuild file
+		If you have two modules, foo.ko and bar.ko, where
+		foo.ko needs symbols from bar.ko, then you can use a
+		common top-level kbuild file so both modules are
+		compiled in the same build. Consider following
+		directory layout:
+
+		./foo/ <= contains foo.ko
+		./bar/ <= contains bar.ko
+
+		The top-level kbuild file would then look like:
+
+		#./Kbuild (or ./Makefile):
 			obj-y := foo/ bar/
 
-		Executing:
-			make -C $KDIR M=`pwd`
+		And executing:
+			$ make -C $KDIR M=$PWD
 
-		will then do the expected and compile both modules with full
-		knowledge on symbols from both modules.
+		Will then do the expected and compile both modules with
+		full knowledge of symbols from either module.
 
 	Use an extra Module.symvers file
-		When an external module is built, a Module.symvers file is
-		generated containing all exported symbols which are not
-		defined in the kernel.
-		To get access to symbols from module 'bar', one can copy the
-		Module.symvers file from the compilation of the 'bar' module
-		to the directory where the 'foo' module is built.
-		During the module build, kbuild will read the Module.symvers
-		file in the directory of the external module and when the
-		build is finished, a new Module.symvers file is created
-		containing the sum of all symbols defined and not part of the
-		kernel.
-
-	Use make variable KBUILD_EXTRA_SYMBOLS in the Makefile
-		If it is impractical to copy Module.symvers from another
-		module, you can assign a space separated list of files to
-		KBUILD_EXTRA_SYMBOLS in your Makfile. These files will be
-		loaded by modpost during the initialisation of its symbol
-		tables.
-
-=== 8. Tips & Tricks
-
---- 8.1 Testing for CONFIG_FOO_BAR
-
-	Modules often need to check for certain CONFIG_ options to decide if
-	a specific feature shall be included in the module. When kbuild is used
-	this is done by referencing the CONFIG_ variable directly.
+		When an external module is built, a Module.symvers file
+		is generated containing all exported symbols which are
+		not defined in the kernel. To get access to symbols
+		from bar.ko, copy the Module.symvers file from the
+		compilation of bar.ko to the directory where foo.ko is
+		built. During the module build, kbuild will read the
+		Module.symvers file in the directory of the external
+		module, and when the build is finished, a new
+		Module.symvers file is created containing the sum of
+		all symbols defined and not part of the kernel.
+
+	Use "make" variable KBUILD_EXTRA_SYMBOLS
+		If it is impractical to copy Module.symvers from
+		another module, you can assign a space separated list
+		of files to KBUILD_EXTRA_SYMBOLS in your build
+		file. These files will be loaded by modpost during the
+		initialization of its symbol tables.
+
+=== 7. Tips & Tricks
+
+--- 7.1 Testing for CONFIG_FOO_BAR
+
+	Modules often need to check for certain CONFIG_ options to
+	decide if a specific feature is included in the module. In
+	kbuild this is done by referencing the CONFIG_ variable
+	directly.
 
 		#fs/ext2/Makefile
 		obj-$(CONFIG_EXT2_FS) += ext2.o
@@ -535,9 +531,9 @@ Module.symvers contains a list of all exported symbols from a kernel build.
 		ext2-y := balloc.o bitmap.o dir.o
 		ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o
 
-	External modules have traditionally used grep to check for specific
-	CONFIG_ settings directly in .config. This usage is broken.
-	As introduced before, external modules shall use kbuild when building
-	and therefore can use the same methods as in-kernel modules when
-	testing for CONFIG_ definitions.
+	External modules have traditionally used "grep" to check for
+	specific CONFIG_ settings directly in .config. This usage is
+	broken. As introduced before, external modules should use
+	kbuild for building and can therefore use the same methods as
+	in-tree modules when testing for CONFIG_ definitions.
 
-- 
1.7.2.1

