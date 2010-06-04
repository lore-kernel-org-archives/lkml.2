Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0FDKi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:38:59 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:41500 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab0FDKi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=X1VLFWlkBmvjtYNGs8W2a9hWloi6ty4E2Xd/XLX+fvXg8Cf/VXi3dxV6Yd3Z1caWKL
         aT8C69BBE+YPwGbAx1ObYZjRNDwM2TqeuaRm0pA7k9ge/cwppS5ZUn2WRSdaZp5yub8U
         JPxXl6TFHxqsRXjhQXfY/ibnFrilDIleQGlB0=
Date: Fri, 4 Jun 2010 12:38:40 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Ben Hutchings <ben@decadent.org.uk>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] Staging: sep: return -EFAULT on copy_to_user errors
Message-ID: <20100604103840.GD5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>,
	Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining but we want to
return a negative error code here.  These functions are used in the
ioctl handler and the error code gets returned to userspace.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 0332c37..ecbde34 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -594,8 +594,10 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	dbg("SEP Driver:--------> sep_allocate_data_pool_memory_handler start\n");
 
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_alloc_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	/* allocate memory */
 	if ((sep->data_pool_bytes_allocated + command_args.num_bytes) > SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
@@ -609,8 +611,10 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 
 	/* write the memory back to the user space */
 	error = copy_to_user((void *) arg, (void *) &command_args, sizeof(struct sep_driver_alloc_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	/* set the allocation */
 	sep->data_pool_bytes_allocated += command_args.num_bytes;
@@ -661,6 +665,8 @@ static int sep_write_into_data_pool_handler(struct sep_device *sep, unsigned lon
 	}
 	/* copy the application data */
 	error = copy_from_user(virt_address, (void *) app_in_address, num_bytes);
+	if (error)
+		error = -EFAULT;
 end_function:
 	dbg("SEP Driver:<-------- sep_write_into_data_pool_handler end\n");
 	return error;
@@ -711,6 +717,8 @@ static int sep_read_from_data_pool_handler(struct sep_device *sep, unsigned long
 
 	/* copy the application data */
 	error = copy_to_user((void *) app_out_address, virt_address, num_bytes);
+	if (error)
+		error = -EFAULT;
 end_function:
 	dbg("SEP Driver:<-------- sep_read_from_data_pool_handler end\n");
 	return error;
@@ -1448,8 +1456,10 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 	dbg("SEP Driver:--------> sep_create_sync_dma_tables_handler start\n");
 
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_build_sync_table_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	edbg("app_in_address is %08lx\n", command_args.app_in_address);
 	edbg("app_out_address is %08lx\n", command_args.app_out_address);
@@ -1799,8 +1809,10 @@ static int sep_create_flow_dma_tables_handler(struct sep_device *sep,
 		goto end_function;
 
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_build_flow_table_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	/* create flow tables */
 	error = sep_prepare_flow_dma_tables(sep, command_args.num_virtual_buffers, command_args.virt_buff_data_addr, flow_context_ptr, &first_table_data, &last_table_data, command_args.isKernelVirtualAddress);
@@ -1819,8 +1831,10 @@ static int sep_create_flow_dma_tables_handler(struct sep_device *sep,
 
 	/* send the parameters to user application */
 	error = copy_to_user((void *) arg, &command_args, sizeof(struct sep_driver_build_flow_table_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function_with_error;
+	}
 
 	/* all the flow created  - update the flow entry with temp id */
 	flow_context_ptr->flow_id = SEP_TEMP_FLOW_ID;
@@ -1861,8 +1875,10 @@ static int sep_add_flow_tables_handler(struct sep_device *sep, unsigned long arg
 
 	/* get input parameters */
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_add_flow_table_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	/* find the flow structure for the flow id */
 	flow_context_ptr = sep_find_flow_context(sep, command_args.flow_id);
@@ -1933,6 +1949,8 @@ static int sep_add_flow_tables_handler(struct sep_device *sep, unsigned long arg
 
 	/* send the parameters to user application */
 	error = copy_to_user((void *) arg, &command_args, sizeof(struct sep_driver_add_flow_table_t));
+	if (error)
+		error = -EFAULT;
 end_function_with_error:
 	/* free the allocated tables */
 	sep_deallocated_flow_tables(&first_table_data);
@@ -1953,8 +1971,10 @@ static int sep_add_flow_tables_message_handler(struct sep_device *sep, unsigned
 	dbg("SEP Driver:--------> sep_add_flow_tables_message_handler start\n");
 
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_add_message_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	/* check input */
 	if (command_args.message_size_in_bytes > SEP_MAX_ADD_MESSAGE_LENGTH_IN_BYTES) {
@@ -1970,6 +1990,8 @@ static int sep_add_flow_tables_message_handler(struct sep_device *sep, unsigned
 	/* copy the message into context */
 	flow_context_ptr->message_size_in_bytes = command_args.message_size_in_bytes;
 	error = copy_from_user(flow_context_ptr->message, (void *) command_args.message_address, command_args.message_size_in_bytes);
+	if (error)
+		error = -EFAULT;
 end_function:
 	dbg("SEP Driver:<-------- sep_add_flow_tables_message_handler end\n");
 	return error;
@@ -1994,6 +2016,8 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep, unsigned lon
 
 	/* send the parameters to user application */
 	error = copy_to_user((void *) arg, &command_args, sizeof(struct sep_driver_static_pool_addr_t));
+	if (error)
+		error = -EFAULT;
 	dbg("SEP Driver:<-------- sep_get_static_pool_addr_handler end\n");
 	return error;
 }
@@ -2010,8 +2034,10 @@ static int sep_get_physical_mapped_offset_handler(struct sep_device *sep, unsign
 	dbg("SEP Driver:--------> sep_get_physical_mapped_offset_handler start\n");
 
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_get_mapped_offset_t));
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
 
 	if (command_args.physical_address < sep->shared_bus) {
 		error = -EINVAL;
@@ -2025,6 +2051,8 @@ static int sep_get_physical_mapped_offset_handler(struct sep_device *sep, unsign
 
 	/* send the parameters to user application */
 	error = copy_to_user((void *) arg, &command_args, sizeof(struct sep_driver_get_mapped_offset_t));
+	if (error)
+		error = -EFAULT;
 end_function:
 	dbg("SEP Driver:<-------- sep_get_physical_mapped_offset_handler end\n");
 	return error;
@@ -2070,11 +2098,11 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	error = 0;
 
 	error = copy_from_user(&command_args, (void *) arg, sizeof(struct sep_driver_init_t));
-
-	dbg("SEP Driver:--------> sep_init_handler - finished copy_from_user \n");
-
-	if (error)
+	if (error) {
+		error = -EFAULT;
 		goto end_function;
+	}
+	dbg("SEP Driver:--------> sep_init_handler - finished copy_from_user\n");
 
 	/* PATCH - configure the DMA to single -burst instead of multi-burst */
 	/*sep_configure_dma_burst(); */
