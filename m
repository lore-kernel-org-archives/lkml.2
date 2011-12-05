Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1LER0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:26:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531Ab1LER01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:26:27 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization <virtualization@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: =?UTF-8?q?Re=3A=20=5BPATCH=20v2=5D=20Add=20virtio-scsi=20to=20the=20virtio=20spec?=
Date: Mon,  5 Dec 2011 18:26:05 +0100
Message-Id: <1323105965-6391-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1323105965-6391-1-git-send-email-pbonzini@redhat.com>
References: <1323105965-6391-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For simplicity, instead of including the whole spec, I am just including
the diff from v1.

--- virtio-spec.txt.v1	2011-11-30 12:21:01.472479754 +0100
+++ virtio-spec.txt	2011-12-05 14:07:02.645044924 +0100
@@ -1,10 +1,9 @@
 Appendix H: SCSI Host Device
 
-The virtio SCSI host device groups together one or more simple 
-virtual devices (ie. disk), and allows communicating to these 
-devices using the SCSI protocol. An instance of the device 
-represents a SCSI host with possibly many buses (also known as 
-channels or paths), targets and LUNs attached.
+The virtio SCSI host device groups together one or more virtual 
+logical units (such as disks), and allows communicating to them using
+the SCSI protocol. An instance of the device represents a SCSI host to
+which many targets and LUNs are attached.
 
 The virtio SCSI device services two kinds of requests:
 
@@ -39,6 +38,8 @@
     struct virtio_scsi_config {
         u32 num_queues;
         u32 seg_max;
+        u32 max_sectors;
+        u32 cmd_per_lun;
         u32 event_info_size;
         u32 sense_size;
         u32 cdb_size;
@@ -47,14 +48,22 @@
         u32 max_lun;
     };
 
-  num_queues is the total number of virtqueues exposed by the 
-    device. The driver is free to use only one request queue, or 
-    it can use more to achieve better performance.
+  num_queues is the total number of request virtqueues exposed by 
+    the device. The driver is free to use only one request queue, 
+    or it can use more to achieve better performance.
 
   seg_max is the maximum number of segments that can be in a 
     command. A bidirectional command can include seg_max input 
     segments and seg_max output segments.
 
+  max_sectors is a hint to the guest about the maximum transfer 
+    size it should use.
+
+  cmd_per_lun is a hint to the guest about the maximum number of 
+    linked commands it should send to one LUN. The actual value 
+    to be used is the minimum of cmd_per_lun and the virtqueue 
+    size.
+
   event_info_size is the maximum size that the device will fill 
     for buffers that the driver places in the eventq. The driver 
     should always put buffers at least of this size. It is 
@@ -72,9 +81,7 @@
     restored to the default when the device is reset.
 
   max_channel, max_target and max_lun can be used by the driver 
-    as hints for scanning the logical units on the host. In the 
-    current version of the spec, they will always be respectively 
-    0, 255 and 16383.
+    as hints to constrain scanning the logical units on the host.
 
 Device Initialization
 =====================
@@ -93,13 +100,15 @@
 ================================
 
 The driver queues requests to an arbitrary request queue, and 
-they are used by the device on that same queue. In this version 
-of the spec, commands placed on different queue will be consumed 
-with _no_ order constraints.
+they are used by the device on that same queue. It is the 
+responsibility of the driver to ensure strict request ordering 
+for commands placed on different queues, because they will be 
+consumed with _no_ order constraints.
 
 Requests have the following format: 
 
     struct virtio_scsi_req_cmd {
+        // Read-only
         u8 lun[8];
         u64 id;
         u8 task_attr;
@@ -107,6 +116,7 @@
         u8 crn;
         char cdb[cdb_size];
         char dataout[];
+        // Write-only part
         u32 sense_len;
         u32 residual;
         u16 status_qualifier;
@@ -122,10 +132,11 @@
     #define VIRTIO_SCSI_S_ABORTED           2
     #define VIRTIO_SCSI_S_BAD_TARGET        3
     #define VIRTIO_SCSI_S_RESET             4
-    #define VIRTIO_SCSI_S_TRANSPORT_FAILURE 5
-    #define VIRTIO_SCSI_S_TARGET_FAILURE    6
-    #define VIRTIO_SCSI_S_NEXUS_FAILURE     7
-    #define VIRTIO_SCSI_S_FAILURE           8
+    #define VIRTIO_SCSI_S_BUSY              5
+    #define VIRTIO_SCSI_S_TRANSPORT_FAILURE 6
+    #define VIRTIO_SCSI_S_TARGET_FAILURE    7
+    #define VIRTIO_SCSI_S_NEXUS_FAILURE     8
+    #define VIRTIO_SCSI_S_FAILURE           9
     
     /* task_attr */
     #define VIRTIO_SCSI_S_SIMPLE            0
@@ -134,22 +145,21 @@
     #define VIRTIO_SCSI_S_ACA               3
 
 The lun field addresses a target and logical unit in the 
-virtio-scsi device's SCSI domain. In this version of the spec, 
-the only supported value of the LUN field is: first byte set to 
-1, second byte set to target, third and fourth byte representing 
-a single level LUN structure, followed by four zero bytes. With 
-this representation, a virtio-scsi device can serve up to 256 
-targets and 16384 LUNs per target. 
+virtio-scsi device's SCSI domain. The only supported format for 
+the LUN field is: first byte set to 1, second byte set to target, 
+third and fourth byte representing a single level LUN structure, 
+followed by four zero bytes. With this representation, a 
+virtio-scsi device can serve up to 256 targets and 16384 LUNs per 
+target.
 
 The id field is the command identifier (“tag”).
 
-Task_attr, prio and crn should be left to zero: command priority 
-is explicitly not supported by this version of the device; 
-task_attr defines the task attribute as in the table above, but 
-all task attributes may be mapped to SIMPLE by the device; crn 
-may also be provided by clients, but is generally expected to be 
-0. The maximum CRN value defined by the protocol is 255, since 
-CRN is stored in an 8-bit integer.
+task_attr, prio and crn should be left to zero. task_attr defines 
+the task attribute as in the table above, but all task attributes 
+may be mapped to SIMPLE by the device; crn may also be provided 
+by clients, but is generally expected to be 0. The maximum CRN 
+value defined by the protocol is 255, since CRN is stored in an 
+8-bit integer.
 
 All of these fields are defined in SAM. They are always 
 read-only, as are the cdb and dataout field. The cdb_size is 
@@ -167,7 +177,7 @@
 processed partially and the datain field was not processed at 
 all.
 
-The status byte is written by the device to be the status 
+The status byte is written by the device to be the status
 code as defined in SAM.
 
 The response byte is written by the device to be one of the 
@@ -180,14 +190,14 @@
   VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires 
   transferring more data than is available in the data buffers.
 
-  VIRTIO_SCSI_S_ABORTED if the request was cancelled due to a 
-  task management function.
+  VIRTIO_SCSI_S_ABORTED if the request was cancelled due to an 
+  ABORT TASK or ABORT TASK SET task management function.
 
   VIRTIO_SCSI_S_BAD_TARGET if the request was never processed 
   because the target indicated by the lun field does not exist.
 
   VIRTIO_SCSI_S_RESET if the request was cancelled due to a bus 
-  or device reset.
+  or device reset (including a task management function).
 
   VIRTIO_SCSI_S_TRANSPORT_FAILURE if the request failed due to a 
   problem in the connection between the host and the target 
@@ -199,6 +209,9 @@
   VIRTIO_SCSI_S_NEXUS_FAILURE if the nexus is suffering a failure 
   but retrying on other paths might yield a different result.
 
+  VIRTIO_SCSI_S_BUSY if the request failed but retrying on the 
+  same path should work.
+
   VIRTIO_SCSI_S_FAILURE for other host or guest error. In 
   particular, if neither dataout nor datain is empty, and the 
   VIRTIO_SCSI_F_INOUT feature has not been negotiated, the 
@@ -220,11 +233,12 @@
     /* response values valid for all commands */
     #define VIRTIO_SCSI_S_OK                       0
     #define VIRTIO_SCSI_S_BAD_TARGET               3
-    #define VIRTIO_SCSI_S_TRANSPORT_FAILURE        5
-    #define VIRTIO_SCSI_S_TARGET_FAILURE           6
-    #define VIRTIO_SCSI_S_NEXUS_FAILURE            7
-    #define VIRTIO_SCSI_S_FAILURE                  8
-    #define VIRTIO_SCSI_S_INCORRECT_LUN            11
+    #define VIRTIO_SCSI_S_BUSY                     5
+    #define VIRTIO_SCSI_S_TRANSPORT_FAILURE        6
+    #define VIRTIO_SCSI_S_TARGET_FAILURE           7
+    #define VIRTIO_SCSI_S_NEXUS_FAILURE            8
+    #define VIRTIO_SCSI_S_FAILURE                  9
+    #define VIRTIO_SCSI_S_INCORRECT_LUN            12
 
 The type identifies the remaining fields.
 
@@ -245,31 +259,31 @@
     
     struct virtio_scsi_ctrl_tmf
     {
+        // Read-only part
         u32 type;
         u32 subtype;
         u8 lun[8];
         u64 id;
-        u8 additional[];
+        // Write-only part
         u8 response;
     }
     
     /* command-specific response values */
     #define VIRTIO_SCSI_S_FUNCTION_COMPLETE        0
-    #define VIRTIO_SCSI_S_FUNCTION_SUCCEEDED       9
-    #define VIRTIO_SCSI_S_FUNCTION_REJECTED        10
+    #define VIRTIO_SCSI_S_FUNCTION_SUCCEEDED       10
+    #define VIRTIO_SCSI_S_FUNCTION_REJECTED        11
 
   The type is VIRTIO_SCSI_T_TMF; the subtype field defines. All 
   fields except response are filled by the driver. The subtype 
   field must always be specified and identifies the requested 
-  task management function. Other fields may be irrelevant for 
-  the requested TMF are ignored. The lun field is in the same 
-  format specified for request queues; the single level LUN is 
-  ignored when the task management function addresses a whole I_T 
-  nexus. When relevant, the value of the id field is matched 
-  against the id values passed on the requestq.
+  task management function.
 
-  Note that since ACA is not supported by this version of the 
-  spec, VIRTIO_SCSI_T_TMF_CLEAR_ACA is always a no-operation.
+  Other fields may be irrelevant for the requested TMF; if so, 
+  they are ignored but they should still be present. The lun 
+  field is in the same format specified for request queues; the 
+  single level LUN is ignored when the task management function 
+  addresses a whole I_T nexus. When relevant, the value of the id 
+  field is matched against the id values passed on the requestq.
 
   The outcome of the task management function is written by the 
   device in the response field. The command-specific response 
@@ -280,9 +294,11 @@
     #define VIRTIO_SCSI_T_AN_QUERY                    1
     
     struct virtio_scsi_ctrl_an {
+        // Read-only part
         u32 type;
         u8  lun[8];
         u32 event_requested;
+        // Write-only part
         u32 event_actual;
         u8  response;
     }
@@ -312,9 +328,11 @@
     #define VIRTIO_SCSI_T_AN_SUBSCRIBE                2
     
     struct virtio_scsi_ctrl_an {
+        // Read-only part
         u32 type;
         u8  lun[8];
         u32 event_requested;
+        // Write-only part
         u32 event_actual;
         u8  response;
     }
@@ -339,9 +357,13 @@
 
 The eventq is used by the device to report information on logical 
 units that are attached to it. The driver should always leave a 
-few buffers ready in the eventq. The device will end up dropping 
-events if it finds no buffer ready. 10-15 buffers should be 
-enough.
+few buffers ready in the eventq. In general, the device will not 
+queue events to cope with an empty eventq, and will end up 
+dropping events if it finds no buffer ready. However, when 
+reporting events for many LUNs (e.g. when a whole target 
+disappears), the device can throttle events to avoid dropping 
+them. For this reason, placing 10-15 buffers on the event queue 
+should be enough.
 
 Buffers are placed in the eventq and filled by the device when 
 interesting events occur. The buffers should be strictly 
@@ -356,6 +378,7 @@
     #define VIRTIO_SCSI_T_EVENTS_MISSED   0x80000000
     
     struct virtio_scsi_event {
+        // Write-only part
         u32 event;
         ...
     }
@@ -391,7 +414,8 @@
 
     #define VIRTIO_SCSI_T_TRANSPORT_RESET  1
     
-    struct virtio_scsi_reset {
+    struct virtio_scsi_event_reset {
+        // Write-only part
         u32 event;
         u8  lun[8];
         u32 reason;
@@ -454,7 +478,8 @@
 
     #define VIRTIO_SCSI_T_ASYNC_NOTIFY     2
 
-    struct virtio_scsi_an_event {
+    struct virtio_scsi_event_an {
+        // Write-only part
         u32 event;
         u8  lun[8];
         u32 reason;
