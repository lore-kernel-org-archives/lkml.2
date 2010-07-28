Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0G1PcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:32:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35205 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0G1Pb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:31:58 -0400
Message-ID: <4C504D66.8090302@ti.com>
Date: Wed, 28 Jul 2010 10:31:50 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "Ramos Falcon, Ernesto" <ernesto@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/5] staging:ti dspbridge: remove unnecessary check for
 NULL pointer in cmm.c
References: <1280328052-31292-1-git-send-email-ernesto@ti.com> <1280328052-31292-2-git-send-email-ernesto@ti.com> <1280328052-31292-3-git-send-email-ernesto@ti.com> <4C504719.3020007@ti.com>
In-Reply-To: <4C504719.3020007@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon had written, on 07/28/2010 10:04 AM, the following:
> Ramos Falcon, Ernesto had written, on 07/28/2010 09:40 AM, the following:
>> Remove unnecessary check for NULL pointer in cmm.c.
>>
>> Signed-off-by: Ernesto Ramos <ernesto@ti.com>
>> ---
>>  drivers/staging/tidspbridge/pmgr/cmm.c |    8 ++------
>>  1 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
>> index 8e808d9..874ed64 100644
>> --- a/drivers/staging/tidspbridge/pmgr/cmm.c
>> +++ b/drivers/staging/tidspbridge/pmgr/cmm.c
>> @@ -992,16 +992,12 @@ int cmm_xlator_create(struct cmm_xlatorobject **xlator,
>>  int cmm_xlator_delete(struct cmm_xlatorobject *xlator, bool force)
>>  {
>>  	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
>> -	int status = 0;
>>  
>>  	DBC_REQUIRE(refs > 0);
>>  
>> -	if (xlator_obj)
>> -		kfree(xlator_obj);
>> -	else
>> -		status = -EFAULT;
>> +	kfree(xlator_obj);
>>  
>> -	return status;
>> +	return 0;
>>  }
>>  
>>  /*
> which kind of begs the question - does this function need to any longer 
> return int?
> 
here is a better approach:
remove cmm_xlator_delete altogether
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c 
b/drivers/staging/tidspbridge/pmgr/cmm.c
index 8e808d9..1a4ebca 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -984,27 +984,6 @@ int cmm_xlator_create(struct cmm_xlatorobject **xlator,
  }

  /*
- *  ======== cmm_xlator_delete ========
- *  Purpose:
- *      Free the Xlator resources.
- *      VM gets freed later.
- */
-int cmm_xlator_delete(struct cmm_xlatorobject *xlator, bool force)
-{
-	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
-	int status = 0;
-
-	DBC_REQUIRE(refs > 0);
-
-	if (xlator_obj)
-		kfree(xlator_obj);
-	else
-		status = -EFAULT;
-
-	return status;
-}
-
-/*
   *  ======== cmm_xlator_alloc_buf ========
   */
  void *cmm_xlator_alloc_buf(struct cmm_xlatorobject *xlator, void *va_buf,
diff --git a/drivers/staging/tidspbridge/rmgr/node.c 
b/drivers/staging/tidspbridge/rmgr/node.c
index 9f07c81..0c39288 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -2503,7 +2503,6 @@ static void delete_node(struct node_object *hnode,
  			struct process_context *pr_ctxt)
  {
  	struct node_mgr *hnode_mgr;
-	struct cmm_xlatorobject *xlator;
  	struct bridge_drv_interface *intf_fxns;
  	u32 i;
  	enum node_type node_type;
@@ -2521,7 +2520,6 @@ static void delete_node(struct node_object *hnode,
  	hnode_mgr = hnode->hnode_mgr;
  	if (!hnode_mgr)
  		goto func_end;
-	xlator = hnode->xlator;
  	node_type = node_get_type(hnode);
  	if (node_type != NODE_DEVICE) {
  		node_msg_args = hnode->create_args.asa.node_msg_args;
@@ -2617,10 +2615,7 @@ static void delete_node(struct node_object *hnode,
  	hnode->dcd_props.obj_data.node_obj.pstr_i_alg_name = NULL;

  	/* Free all SM address translator resources */
-	if (xlator) {
-		(void)cmm_xlator_delete(xlator, true);	/* force free */
-		xlator = NULL;
-	}
+	kfree(hnode->xlator);

  	kfree(hnode->nldr_node_obj);
  	hnode->nldr_node_obj = NULL;
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c 
b/drivers/staging/tidspbridge/rmgr/strm.c
index 73888e3..05a8d13 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -844,14 +844,8 @@ static int delete_strm(struct strm_object *stream_obj)
  			status = (*intf_fxns->pfn_chnl_close)
  					(stream_obj->chnl_obj);
  			/* Free all SM address translator resources */
-			if (DSP_SUCCEEDED(status)) {
-				if (stream_obj->xlator) {
-					/* force free */
-					(void)cmm_xlator_delete(stream_obj->
-								xlator,
-								true);
-				}
-			}
+			if (DSP_SUCCEEDED(status))
+				kfree(stream_obj->xlator);
  		}
  		kfree(stream_obj);
  	} else {
-- 
Regards,
Nishanth Menon
