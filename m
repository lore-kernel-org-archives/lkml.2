Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2E3OV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:21:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38942 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2E3OVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:21:21 -0400
MIME-Version: 1.0
Date: Wed, 30 May 2012 07:21:17 -0700
Message-ID: <CALofOnUCv9V4bxHQ=ykn13_=SSyP93pk7bU_FbgX5YAhOC95pQ@mail.gmail.com>
Subject: fix IPMI I/O error on NEC FC storage array
From: Naresh Bhat <nbhat@mvista.com>
To: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d0447a06b1fd1ca04c141aa97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0447a06b1fd1ca04c141aa97
Content-Type: text/plain; charset=ISO-8859-1

Hi,

The code changes will fix the IPMI I/O error on NEC FC storage array.

===========================================================================================

Signed-off-by: Naresh Bhat <nbhat@mvista.com>
--- linux-2.6.32.59/drivers/char/ipmi/ipmi_kcs_sm.c.orig	2012-05-31
06:11:54.753480863 -0700
+++ linux-2.6.32.59/drivers/char/ipmi/ipmi_kcs_sm.c	2012-05-31
06:21:26.780977397 -0700
@@ -344,6 +344,24 @@ static int get_kcs_result(struct si_sm_d
  */
 static enum si_sm_result kcs_event(struct si_sm_data *kcs, long time)
 {
+#define READ_STATUS_MAX_LOOP 4
+#define SI_SM_WAIT_STATE(_state_) \
+	do { \
+		int i; \
+		for (i = 0; (i < READ_STATUS_MAX_LOOP) \
+				&& (state != _state_); i++) { \
+				state = GET_STATUS_STATE(read_status(kcs)); \
+		} \
+	} while (0);
+
+#define SI_SM_WAIT_STATE2(_state_, _state2_) \
+	do { \
+		int i; \
+		for (i = 0; (i < READ_STATUS_MAX_LOOP) && \
+			(state != _state_) && (state != _state2_); i++) { \
+				state = GET_STATUS_STATE(read_status(kcs)); \
+		} \
+	} while (0);
 	unsigned char status;
 	unsigned char state;

@@ -370,6 +388,7 @@ static enum si_sm_result kcs_event(struc
 			return SI_SM_IDLE;

 	case KCS_START_OP:
+	SI_SM_WAIT_STATE(KCS_IDLE_STATE);
 		if (state != KCS_IDLE) {
 			start_error_recovery(kcs,
 					     "State machine not idle at start");
@@ -382,6 +401,7 @@ static enum si_sm_result kcs_event(struc
 		break;

 	case KCS_WAIT_WRITE_START:
+	SI_SM_WAIT_STATE(KCS_WRITE_STATE);
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(
 				kcs,
@@ -399,6 +419,7 @@ static enum si_sm_result kcs_event(struc
 		break;

 	case KCS_WAIT_WRITE:
+	SI_SM_WAIT_STATE(KCS_WRITE_STATE);
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(kcs,
 					     "Not in write state for write");
@@ -414,6 +435,7 @@ static enum si_sm_result kcs_event(struc
 		break;

 	case KCS_WAIT_WRITE_END:
+	SI_SM_WAIT_STATE(KCS_WRITE_STATE);
 		if (state != KCS_WRITE_STATE) {
 			start_error_recovery(kcs,
 					     "Not in write state"
@@ -426,6 +448,7 @@ static enum si_sm_result kcs_event(struc
 		break;

 	case KCS_WAIT_READ:
+	SI_SM_WAIT_STATE2(KCS_READ_STATE, KCS_IDLE_STATE);
 		if ((state != KCS_READ_STATE) && (state != KCS_IDLE_STATE)) {
 			start_error_recovery(
 				kcs,
@@ -472,6 +495,7 @@ static enum si_sm_result kcs_event(struc
 		break;

 	case KCS_ERROR2:
+	SI_SM_WAIT_STATE(KCS_READ_STATE);
 		if (state != KCS_READ_STATE) {
 			start_error_recovery(kcs,
 					     "Not in read state for error2");
@@ -486,6 +510,7 @@ static enum si_sm_result kcs_event(struc
 		break;

 	case KCS_ERROR3:
+	SI_SM_WAIT_STATE(KCS_IDLE_STATE);
 		if (state != KCS_IDLE_STATE) {
 			start_error_recovery(kcs,
 					     "Not in idle state for error3");

===========================================================================================


Thanks
-Naresh Bhat

--f46d0447a06b1fd1ca04c141aa97
Content-Type: application/octet-stream; 
	name="Fix-IPMI-I-O-error-on-NEC-FC-storage-array.patch"
Content-Disposition: attachment; 
	filename="Fix-IPMI-I-O-error-on-NEC-FC-storage-array.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2vwnmgs0

U2lnbmVkLW9mZi1ieTogTmFyZXNoIEJoYXQgPG5iaGF0QG12aXN0YS5jb20+Ci0tLSBsaW51eC0y
LjYuMzIuNTkvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9rY3Nfc20uYy5vcmlnCTIwMTItMDUtMzEg
MDY6MTE6NTQuNzUzNDgwODYzIC0wNzAwCisrKyBsaW51eC0yLjYuMzIuNTkvZHJpdmVycy9jaGFy
L2lwbWkvaXBtaV9rY3Nfc20uYwkyMDEyLTA1LTMxIDA2OjIxOjI2Ljc4MDk3NzM5NyAtMDcwMApA
QCAtMzQ0LDYgKzM0NCwyNCBAQCBzdGF0aWMgaW50IGdldF9rY3NfcmVzdWx0KHN0cnVjdCBzaV9z
bV9kCiAgKi8KIHN0YXRpYyBlbnVtIHNpX3NtX3Jlc3VsdCBrY3NfZXZlbnQoc3RydWN0IHNpX3Nt
X2RhdGEgKmtjcywgbG9uZyB0aW1lKQogeworI2RlZmluZSBSRUFEX1NUQVRVU19NQVhfTE9PUCA0
CisjZGVmaW5lIFNJX1NNX1dBSVRfU1RBVEUoX3N0YXRlXykgXAorCWRvIHsgXAorCQlpbnQgaTsg
XAorCQlmb3IgKGkgPSAwOyAoaSA8IFJFQURfU1RBVFVTX01BWF9MT09QKSBcCisJCQkJJiYgKHN0
YXRlICE9IF9zdGF0ZV8pOyBpKyspIHsgXAorCQkJCXN0YXRlID0gR0VUX1NUQVRVU19TVEFURShy
ZWFkX3N0YXR1cyhrY3MpKTsgXAorCQl9IFwKKwl9IHdoaWxlICgwKTsKKworI2RlZmluZSBTSV9T
TV9XQUlUX1NUQVRFMihfc3RhdGVfLCBfc3RhdGUyXykgXAorCWRvIHsgXAorCQlpbnQgaTsgXAor
CQlmb3IgKGkgPSAwOyAoaSA8IFJFQURfU1RBVFVTX01BWF9MT09QKSAmJiBcCisJCQkoc3RhdGUg
IT0gX3N0YXRlXykgJiYgKHN0YXRlICE9IF9zdGF0ZTJfKTsgaSsrKSB7IFwKKwkJCQlzdGF0ZSA9
IEdFVF9TVEFUVVNfU1RBVEUocmVhZF9zdGF0dXMoa2NzKSk7IFwKKwkJfSBcCisJfSB3aGlsZSAo
MCk7CiAJdW5zaWduZWQgY2hhciBzdGF0dXM7CiAJdW5zaWduZWQgY2hhciBzdGF0ZTsKIApAQCAt
MzcwLDYgKzM4OCw3IEBAIHN0YXRpYyBlbnVtIHNpX3NtX3Jlc3VsdCBrY3NfZXZlbnQoc3RydWMK
IAkJCXJldHVybiBTSV9TTV9JRExFOwogCiAJY2FzZSBLQ1NfU1RBUlRfT1A6CisJU0lfU01fV0FJ
VF9TVEFURShLQ1NfSURMRV9TVEFURSk7CiAJCWlmIChzdGF0ZSAhPSBLQ1NfSURMRSkgewogCQkJ
c3RhcnRfZXJyb3JfcmVjb3Zlcnkoa2NzLAogCQkJCQkgICAgICJTdGF0ZSBtYWNoaW5lIG5vdCBp
ZGxlIGF0IHN0YXJ0Iik7CkBAIC0zODIsNiArNDAxLDcgQEAgc3RhdGljIGVudW0gc2lfc21fcmVz
dWx0IGtjc19ldmVudChzdHJ1YwogCQlicmVhazsKIAogCWNhc2UgS0NTX1dBSVRfV1JJVEVfU1RB
UlQ6CisJU0lfU01fV0FJVF9TVEFURShLQ1NfV1JJVEVfU1RBVEUpOwogCQlpZiAoc3RhdGUgIT0g
S0NTX1dSSVRFX1NUQVRFKSB7CiAJCQlzdGFydF9lcnJvcl9yZWNvdmVyeSgKIAkJCQlrY3MsCkBA
IC0zOTksNiArNDE5LDcgQEAgc3RhdGljIGVudW0gc2lfc21fcmVzdWx0IGtjc19ldmVudChzdHJ1
YwogCQlicmVhazsKIAogCWNhc2UgS0NTX1dBSVRfV1JJVEU6CisJU0lfU01fV0FJVF9TVEFURShL
Q1NfV1JJVEVfU1RBVEUpOwogCQlpZiAoc3RhdGUgIT0gS0NTX1dSSVRFX1NUQVRFKSB7CiAJCQlz
dGFydF9lcnJvcl9yZWNvdmVyeShrY3MsCiAJCQkJCSAgICAgIk5vdCBpbiB3cml0ZSBzdGF0ZSBm
b3Igd3JpdGUiKTsKQEAgLTQxNCw2ICs0MzUsNyBAQCBzdGF0aWMgZW51bSBzaV9zbV9yZXN1bHQg
a2NzX2V2ZW50KHN0cnVjCiAJCWJyZWFrOwogCiAJY2FzZSBLQ1NfV0FJVF9XUklURV9FTkQ6CisJ
U0lfU01fV0FJVF9TVEFURShLQ1NfV1JJVEVfU1RBVEUpOwogCQlpZiAoc3RhdGUgIT0gS0NTX1dS
SVRFX1NUQVRFKSB7CiAJCQlzdGFydF9lcnJvcl9yZWNvdmVyeShrY3MsCiAJCQkJCSAgICAgIk5v
dCBpbiB3cml0ZSBzdGF0ZSIKQEAgLTQyNiw2ICs0NDgsNyBAQCBzdGF0aWMgZW51bSBzaV9zbV9y
ZXN1bHQga2NzX2V2ZW50KHN0cnVjCiAJCWJyZWFrOwogCiAJY2FzZSBLQ1NfV0FJVF9SRUFEOgor
CVNJX1NNX1dBSVRfU1RBVEUyKEtDU19SRUFEX1NUQVRFLCBLQ1NfSURMRV9TVEFURSk7CiAJCWlm
ICgoc3RhdGUgIT0gS0NTX1JFQURfU1RBVEUpICYmIChzdGF0ZSAhPSBLQ1NfSURMRV9TVEFURSkp
IHsKIAkJCXN0YXJ0X2Vycm9yX3JlY292ZXJ5KAogCQkJCWtjcywKQEAgLTQ3Miw2ICs0OTUsNyBA
QCBzdGF0aWMgZW51bSBzaV9zbV9yZXN1bHQga2NzX2V2ZW50KHN0cnVjCiAJCWJyZWFrOwogCiAJ
Y2FzZSBLQ1NfRVJST1IyOgorCVNJX1NNX1dBSVRfU1RBVEUoS0NTX1JFQURfU1RBVEUpOwogCQlp
ZiAoc3RhdGUgIT0gS0NTX1JFQURfU1RBVEUpIHsKIAkJCXN0YXJ0X2Vycm9yX3JlY292ZXJ5KGtj
cywKIAkJCQkJICAgICAiTm90IGluIHJlYWQgc3RhdGUgZm9yIGVycm9yMiIpOwpAQCAtNDg2LDYg
KzUxMCw3IEBAIHN0YXRpYyBlbnVtIHNpX3NtX3Jlc3VsdCBrY3NfZXZlbnQoc3RydWMKIAkJYnJl
YWs7CiAKIAljYXNlIEtDU19FUlJPUjM6CisJU0lfU01fV0FJVF9TVEFURShLQ1NfSURMRV9TVEFU
RSk7CiAJCWlmIChzdGF0ZSAhPSBLQ1NfSURMRV9TVEFURSkgewogCQkJc3RhcnRfZXJyb3JfcmVj
b3Zlcnkoa2NzLAogCQkJCQkgICAgICJOb3QgaW4gaWRsZSBzdGF0ZSBmb3IgZXJyb3IzIik7Cg==
--f46d0447a06b1fd1ca04c141aa97--
