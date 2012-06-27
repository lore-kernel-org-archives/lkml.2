Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2F0ATv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:19:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2F0ATu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:19:50 -0400
Date: Tue, 26 Jun 2012 17:19:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naresh Bhat <nbhat@mvista.com>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: fix IPMI I/O error on NEC FC storage array
Message-Id: <20120626171949.74a0536d.akpm@linux-foundation.org>
In-Reply-To: <CALofOnUCv9V4bxHQ=ykn13_=SSyP93pk7bU_FbgX5YAhOC95pQ@mail.gmail.com>
References: <CALofOnUCv9V4bxHQ=ykn13_=SSyP93pk7bU_FbgX5YAhOC95pQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012 07:21:17 -0700
Naresh Bhat <nbhat@mvista.com> wrote:

> Hi,
> 
> The code changes will fix the IPMI I/O error on NEC FC storage array.

When fixing a bug, please fully describe that bug.  This helps people
to work out which kernel version(s) should be patched and helps others
work out whether your patch will fix a problem which they or their
customers are seeing.

> Signed-off-by: Naresh Bhat <nbhat@mvista.com>
> --- linux-2.6.32.59/drivers/char/ipmi/ipmi_kcs_sm.c.orig	2012-05-31
> 06:11:54.753480863 -0700
> +++ linux-2.6.32.59/drivers/char/ipmi/ipmi_kcs_sm.c	2012-05-31
> 06:21:26.780977397 -0700

Your email client is wordwrapping the patches.

> @@ -344,6 +344,24 @@ static int get_kcs_result(struct si_sm_d
>   */
>  static enum si_sm_result kcs_event(struct si_sm_data *kcs, long time)
>  {
> +#define READ_STATUS_MAX_LOOP 4
> +#define SI_SM_WAIT_STATE(_state_) \
> +	do { \
> +		int i; \
> +		for (i = 0; (i < READ_STATUS_MAX_LOOP) \
> +				&& (state != _state_); i++) { \
> +				state = GET_STATUS_STATE(read_status(kcs)); \
> +		} \
> +	} while (0);
> +
> +#define SI_SM_WAIT_STATE2(_state_, _state2_) \
> +	do { \
> +		int i; \
> +		for (i = 0; (i < READ_STATUS_MAX_LOOP) && \
> +			(state != _state_) && (state != _state2_); i++) { \
> +				state = GET_STATUS_STATE(read_status(kcs)); \
> +		} \
> +	} while (0);
>  	unsigned char status;
>  	unsigned char state;
> 
> @@ -370,6 +388,7 @@ static enum si_sm_result kcs_event(struc
>  			return SI_SM_IDLE;
> 
>  	case KCS_START_OP:
> +	SI_SM_WAIT_STATE(KCS_IDLE_STATE);

This is really ugly :(

Please convert the above two macros into regular C functions.  Please
ensure that those functions are suitably commented.  Something like

	state = si_sm_wait_state(kcs, KCS_IDLE_STATE);

note that we don't pass `state' into si_sm_wait_state().  let's remove
the "Just about everything looks at the KCS stat" assignment and do the
read within those switch cases which actually need it.


Here, like this:

--- a/drivers/char/ipmi/ipmi_kcs_sm.c~fix-ipmi-i-o-error-on-nec-fc-storage-array
+++ a/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -337,6 +337,40 @@ static int get_kcs_result(struct si_sm_d
 	return kcs->read_pos;
 }
 
+#define READ_STATUS_MAX_LOOP 4
+
+/*
+ * comment goes here
+ */
+static int si_sm_wait_state(struct si_sm_data *kcs, int state)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < READ_STATUS_MAX_LOOP; i++) {
+		ret = GET_STATUS_STATE(read_status(kcs));
+		if (ret == state)
+			break;
+	}
+	return ret;
+}
+
+/*
+ * comment goes here
+ */
+static int si_sm_wait_state2(struct si_sm_data *kcs, int state1, int state2)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < READ_STATUS_MAX_LOOP; i++) {
+		ret = GET_STATUS_STATE(read_status(kcs));
+		if (ret == state1 || ret == state2)
+			break;
+	}
+	return ret;
+}
+
 /*
  * This implements the state machine defined in the IPMI manual, see
  * that for details on how this works.  Divide that flowchart into
@@ -356,9 +390,6 @@ static enum si_sm_result kcs_event(struc
 	if (!check_ibf(kcs, status, time))
 		return SI_SM_CALL_WITH_DELAY;
 
-	/* Just about everything looks at the KCS state, so grab that, too. */
-	state = GET_STATUS_STATE(status);
-
 	switch (kcs->state) {
 	case KCS_IDLE:
 		/* If there's and interrupt source, turn it off. */
@@ -370,6 +401,7 @@ static enum si_sm_result kcs_event(struc
 			return SI_SM_IDLE;
 
 	case KCS_START_OP:
+		state = si_sm_wait_state(kcs, KCS_IDLE_STATE);
 		if (state != KCS_IDLE_STATE) {
 			start_error_recovery(kcs,
 					     "State machine not idle at start");
@@ -382,6 +414,7 @@ static enum si_sm_result kcs_event(struc
 		break;
 
 	case KCS_WAIT_WRITE_START:
+		state = si_sm_wait_state(kcs, KCS_WRITE_STATE);
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(
 				kcs,
@@ -399,6 +432,7 @@ static enum si_sm_result kcs_event(struc
 		break;
 
 	case KCS_WAIT_WRITE:
+		state = si_sm_wait_state(kcs, KCS_WRITE_STATE);
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(kcs,
 					     "Not in write state for write");
@@ -414,6 +448,7 @@ static enum si_sm_result kcs_event(struc
 		break;
 
 	case KCS_WAIT_WRITE_END:
+		state = si_sm_wait_state(kcs, KCS_WRITE_STATE);
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(kcs,
 					     "Not in write state"
@@ -426,6 +461,7 @@ static enum si_sm_result kcs_event(struc
 		break;
 
 	case KCS_WAIT_READ:
+		state = si_sm_wait_state2(kcs, KCS_READ_STATE, KCS_IDLE_STATE);
 		if ((state != KCS_READ_STATE) && (state != KCS_IDLE_STATE)) {
 			start_error_recovery(
 				kcs,
@@ -472,6 +508,7 @@ static enum si_sm_result kcs_event(struc
 		break;
 
 	case KCS_ERROR2:
+		state = si_sm_wait_state(kcs, KCS_READ_STATE);
 		if (state != KCS_READ_STATE) {
 			start_error_recovery(kcs,
 					     "Not in read state for error2");
@@ -486,6 +523,7 @@ static enum si_sm_result kcs_event(struc
 		break;
 
 	case KCS_ERROR3:
+		state = si_sm_wait_state(kcs, KCS_IDLE_STATE);
 		if (state != KCS_IDLE_STATE) {
 			start_error_recovery(kcs,
 					     "Not in idle state for error3");
_

