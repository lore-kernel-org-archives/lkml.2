Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1AJSJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:09:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60242 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1AJSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:09:03 -0500
Message-ID: <4D2B4B38.80102@austin.ibm.com>
Date: Mon, 10 Jan 2011 12:08:56 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: [PATCH 0/4] De-couple sysfs memory directories from memory sections
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-send of the remaining patches that did not make it
into the last kernel release for de-coupling sysfs memory
directories from memory sections.  The first three patches of the
previous set went in, and this is the remaining patches that
need to be applied.

The patches decouple the concept that a single memory
section corresponds to a single directory in 
/sys/devices/system/memory/.  On systems
with large amounts of memory (1+ TB) there are performance issues
related to creating the large number of sysfs directories.  For
a powerpc machine with 1 TB of memory we are creating 63,000+
directories.  This is resulting in boot times of around 45-50
minutes for systems with 1 TB of memory and 8 hours for systems
with 2 TB of memory.  With this patch set applied I am now seeing
boot times of 5 minutes or less.

The root of this issue is in sysfs directory creation. Every time
a directory is created a string compare is done against all sibling
directories to ensure we do not create duplicates.  The list of
directory nodes in sysfs is kept as an unsorted list which results
in this being an exponentially longer operation as the number of
directories are created.

The solution solved by this patch set is to allow a single
directory in sysfs to span multiple memory sections.  This is
controlled by an optional architecturally defined function
memory_block_size_bytes().  The default definition of this
routine returns a memory block size equal to the memory section
size. This maintains the current layout of sysfs memory
directories as it appears to userspace to remain the same as it
is today.

For architectures that define their own version of this routine,
as is done for powerpc and x86 in this patchset, the view in userspace
would change such that each memoryXXX directory would span
multiple memory sections.  The number of sections spanned would
depend on the value reported by memory_block_size_bytes.

-Nathan Fontenot
