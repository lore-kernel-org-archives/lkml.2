Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2CGRKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:10:44 -0500
Received: from bay0-omc1-s22.bay0.hotmail.com ([65.54.190.33]:25651 "EHLO
	bay0-omc1-s22.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217Ab2CGRKn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:10:43 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 12:10:43 EST
Message-ID: <BAY167-W124DBC204D9E95FC00BAA44BD560@phx.gbl>
X-Originating-IP: [66.87.0.153]
From: Xiachen Dong <xiachendong@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.36 and higher version kernel slower than 2.6.25.1 kernel?
Date: Wed, 7 Mar 2012 12:04:33 -0500
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Mar 2012 17:04:33.0244 (UTC) FILETIME=[5E27A1C0:01CCFC84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Recently we upgrade the OS for our AT91RM9200 platform from 2.6.25.1 to 2.6.36. We run the SQLITE3 database insertion tests for the new kernel. The test result shows that 2.6.36 kernel is around 10% slower than the 2.6.25.1.

The sqlite3 database insertion test originates from http://www.phoronix-test-suite.com/?k=home. It is very simple: it creates a new database under current directory and simply keeps on inserting 2500 records into the new DB created. Then it calculates the time it takes to finish the task.

Here's how we run the test:

1) Install or port sqlite3 to the platform;
2) mke2fs /dev/ram0;
3) mount -t ext2 /dev/ram0 /mnt/temp;
4) cp sqliteInsertionTest.sh /mnt/temp;
   cp sqlite-insertions.txt /mnt/temp;
5) cd /mnt/temp;
6) ./sqliteInsertionTest.sh;
7) repeat the test 10 times and take the average;

To narrow down the problem. We also ran similar tests on a Pentium IV 1.7G laptop. Here is how the test was run:

a) install sqlite3 on the laptop
b) compile the 2.6.25.1 and 2.6.36 kernel on the laptop, try to make the kernel config as similar as possible;
c) boot into 2.6.25.1 and 2.6.36 kernel in single user mode ("single" in commandline argument);
d) run same tests in step 2) to step 7) above

The P4 CPU is single core, no hyper-threading. We can still see the performance hit in the 2.6.36 kernel on the Pentium laptop.

We may attach the kernel config files if needed. We choose CFQ for the scheduler for both kernels.


Here is the content of sqliteInsertionTest.sh:

============ sqliteInsertionTest.sh ===========
#!/bin/sh

TEST_PATH=`pwd`
rm -f $TEST_PATH/benchmark.db

echo "`date`, starting test ..."

sqlite3 $TEST_PATH/benchmark.db  "CREATE TABLE pts1 ('I' SMALLINT NOT NULL, 'DT' TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 'F1' VARCHAR(4) NOT NULL, 'F2' VARCHAR(16) NOT NULL);"

cat $TEST_PATH/sqlite-insertions.txt | sqlite3 $TEST_PATH/benchmark.db
...
#cat $TEST_PATH/sqlite-insertions.txt | sqlite3 $TEST_PATH/benchmark.db
#cat $TEST_PATH/sqlite-insertions.txt | sqlite3 $TEST_PATH/behchmark.db

echo "`date`, test done."
============ end of sqliteInsertionTest.sh ===========

sqlite-insertions.txt is very simple:

INSERT INTO 'pts1' ('I', 'DT', 'F1', 'F2') VALUES ('1', CURRENT_TIMESTAMP, '6758', '9844343722998287');
INSERT INTO 'pts1' ('I', 'DT', 'F1', 'F2') VALUES ('2', CURRENT_TIMESTAMP, '3733', '8925952369645997');
...
INSERT INTO 'pts1' ('I', 'DT', 'F1', 'F2') VALUES ('2499', CURRENT_TIMESTAMP, '5955', '1088209297553915');
INSERT INTO 'pts1' ('I', 'DT', 'F1', 'F2') VALUES ('2500', CURRENT_TIMESTAMP, '6086', '6839549078383414');

The other thing we notice is that if the test is run under tempfs, the insertion can be done faster. However, there is still performance hit in 2.6.36 kernel.

We also run the same test on 3.0.23 kernel on the Pentium 4 laptop. The performance hit still exist.

Our questions are:
1. Is anyone else on the list notice such issue?
2. Did we did something silly in running such performance tests?
3. Are there any new features in 2.6.36 kernel that we didn't enable and those disabled features lead to our current test result?

Any suggestions and comments will be greatly appreciated.

Thank you.

Xiachen

 		 	   		  