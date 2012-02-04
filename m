Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2BDNgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 08:36:35 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54573 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2BDNgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 08:36:33 -0500
Message-ID: <4F2D3455.4020505@linux.vnet.ibm.com>
Date: Sat, 04 Feb 2012 19:06:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM/Hibernate: Refactor and simplify freezer_test_done
References: <20120202014014.11863.86758.stgit@srivatsabhat.in.ibm.com> <20120202171727.GE19837@google.com>
In-Reply-To: <20120202171727.GE19837@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020413-2000-0000-0000-0000064CE405
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 10:47 PM, Tejun Heo wrote:

> On Thu, Feb 02, 2012 at 07:10:19AM +0530, Srivatsa S. Bhat wrote:
>> @@ -251,10 +251,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>>  		error = hibernation_snapshot(data->platform_support);
>>  		if (!error) {
>>  			error = put_user(in_suspend, (int __user *)arg);
>> -			if (!error && !freezer_test_done)
>> -				data->ready = 1;
>>  			if (freezer_test_done)
>>  				freezer_test_done = false;
>> +			else if (!error)
>> +				data->ready = 1;
> 
> Hmmm... how about..
> 
> 	data->ready = !freezer_test_done && !error;
> 	freezer_test_done = false;
> 


That looks even better, thanks!

Here is the updated patch:

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Hibernate: Refactor and simplify freezer_test_done

The code related to 'freezer_test_done' is needlessly convoluted.
Refactor the code and simplify the implementation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |   10 +++++-----
 kernel/power/user.c      |    6 ++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index c6dee73..72baaf0 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -629,12 +629,8 @@ int hibernate(void)
 		goto Finish;
 
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
-	if (error)
-		goto Thaw;
-	if (freezer_test_done) {
-		freezer_test_done = false;
+	if (error || freezer_test_done)
 		goto Thaw;
-	}
 
 	if (in_suspend) {
 		unsigned int flags = 0;
@@ -659,6 +655,10 @@ int hibernate(void)
 
  Thaw:
 	thaw_processes();
+
+	/* Don't bother checking whether freezer_test_done is true */
+	freezer_test_done = false;
+
  Finish:
 	free_basic_memory_bitmaps();
 	usermodehelper_enable();
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 7bee91f..33c4329 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -251,10 +251,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = hibernation_snapshot(data->platform_support);
 		if (!error) {
 			error = put_user(in_suspend, (int __user *)arg);
-			if (!error && !freezer_test_done)
-				data->ready = 1;
-			if (freezer_test_done)
-				freezer_test_done = false;
+			data->ready = !freezer_test_done && !error;
+			freezer_test_done = false;
 		}
 		break;
 


