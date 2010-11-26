Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0KZQ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:26:01 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59317 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab0KZQZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:25:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:content-type:content-transfer-encoding:subject:date:message-id
         :to:mime-version:x-mailer;
        b=qH5KnqHqSnFWm0E7a9e7utr58RmhkUyz6Cn11sbXaJ3Wi8BVdtzVxVUxI3Cy3myzv1
         Tp9fWbETvjQ3YE6ZDdIAoFfGCA+Gbb2gyCUgedK3oSU4oGAibmMqlVbl6WeWiylpjbke
         cy6wxitpzlg6s3+FYzkFCaMFENAGCVEBscVdI=
From: Bob Walters <bob.s.walters@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: mlock'ed pages are paging out to shared mapped files?
Date: Fri, 26 Nov 2010 11:25:55 -0500
Message-Id: <03A305FE-2E9E-42B0-A06C-564E03295B2A@gmail.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC directly, I'm not subscribed.

I'm writing to determine if observed mlock behavior is a bug or the intended implementation.   The kernel seems to be paging out modifications made to locked pages of a shared (MAP_SHARED) memory mapped regular file, on Linux 2.6.35.6-48 (Fedora 14 distro, x86_64).   Man pages implies that this might be a bug.   I have a repeatable process involving the following test:

	static const int pages = 64;
	static const size_t pagesize = getpagesize();
	static char *addr = NULL;

	// Make sure, on Linux, that the process has the capability to lock memory.
	// See man capability(7)
	void print_mlock_capability() {
        	cap_t caps = cap_get_proc();
        	if (caps == NULL) {
                	perror("cap_get_proc()");
                	exit(0);
        	}

       		cap_flag_value_t value;
        	cap_get_flag(caps, CAP_IPC_LOCK, CAP_PERMITTED, &value);
        	cout << "IPC_LOCK Permitted: " << (value == CAP_SET ? "set" : "clear") << endl;

        	cap_get_flag(caps, CAP_IPC_LOCK, CAP_EFFECTIVE, &value);
        	cout << "IPC_LOCK Effective: " << (value == CAP_SET ? "set" : "clear") << endl;
	}

	int main(const int argc, const char* argv[]) {
        	print_mlock_capability();

        	int fd = open("mincore_testmap", O_RDWR | O_CREAT, 0777);
        	assert(fd != -1);

        	off_t length = pagesize*pages;
        	char byte=0;
        	ssize_t written = pwrite(fd, &byte, sizeof(char), length);
        	assert(written != -1);

        	int prot = PROT_READ|PROT_WRITE;
        	//int flags = MAP_PRIVATE | MAP_NOCACHE;
        	int flags = MAP_SHARED;
        	//int flags = MAP_SHARED | MAP_NORESERVE;
       		addr = (char*)mmap(0, length, prot, flags, fd, 0);
        	assert(addr != 0);

        	cout << "Mapping at: " << (void*)addr << endl;
        	memset(addr,0,pagesize*pages);
        	msync(addr,length,MS_SYNC);

                cout << "Locking page 0 in memory" << endl;
                // lock page 0 into memory
                int rc = mlock(addr, pagesize);
                if (rc != 0) {
                        perror("mlock");
                        exit(0);
                }

        	// modify page 0 and 1.  1 should page out, but not 0.
        	memset(addr, 127, pagesize*2);

        	cout << "Page 0 and 1 modified, but not synced.  Waiting...." << endl;
        	sleep( 300 );
	}

Output:
IPC_LOCK Permitted: set
IPC_LOCK Effective: set
Mapping at: 0x7fb3b0db7000
Page 0 and 1 modified, but not synched.  Waiting....

After allowing the process to enter the blocked state (sleep), I wait about a 30-60 seconds, then do a sudden power-off by pulling the plug, not allowing the OS any opportunity to react.  I reboot, and can confirm that after reboot, the modifications made to page 0 are seen on disk (via hexdump of the file mincore_test).  More specifically:  On occasion when doing this, I do reboot and see neither pages 0 and 1 on disk.  That's observed if I kill the power quickly after the process reaches the sleep state.  However, after a longer wait (10 seconds+), I always see 127s for both pages 0 and 1 on disk, never just page 1.  I'm using a journaled ext-4 filesystem.  Have checked the file times, after recovery, to rule out the chance that I am seeing a copy from a previous run of this test.

Tried double checking my permission to lock memory.  Ended up running as root.  capacity(7) shows I have IPC_LOCK permissions.  set ulimit -l unlimited.  mlock return code is 0.  I am running SE linux, changed it's configuration to permissive mode to try to rule it out.  Saw no SE Errors.  Can't identify any reason why I would fail to lock the pages into memory.

Ultimately, was unable to prevent mlock'ed pages from being paged out.  I don't know if this occur with swap as well as mapped files - the problem might be specific to the case of a MAP_SHARED regular file?  Don't know.

Is this a bug, or is this the intended behavior.  Many resources (man/web) imply that mlock keeps a locked page from paging out to disk (swap specifically).  The posix standard seems to imply that it must simply prevents eviction, but is not required to avoid paging out.  It is only required to keep the pages memory resident until unlocked.  It would be really nice, for my purposes, if there was some way to guarantee that modified pages of a mapped file do not page out prior to some point in time.  As a side question: Is there another mechanism which can ensure that.

Best Regards,
Bob




