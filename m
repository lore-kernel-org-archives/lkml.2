Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1AaQ3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:29:08 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54691 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1AaQ3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:29:07 -0500
Date: Mon, 31 Jan 2011 17:29:01 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: question about drivers/acpi/sysfs.c
Message-ID: <Pine.LNX.4.64.1101311719380.16049@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function acpi_tables_sysfs_init contains two calls to 
kobject_create_and_add and then a loop, 
and then at the end tests a function return value and returns either 0 or 
-EINVAL.  If the second call to kobject_create_and_add fails, then the 
result of the first one is freed, returning -ENOMEM.  On the other hand, 
inside the loop, there are some possible failures that don't free the 
kobject_create_and_add allocated memory.  This memory does appear to be 
accessible from a global pointer, acpi_kobj, but there is now one -ENOMEM 
case where the data has been freed and one case (from inside the loop) 
where it has not.  Also the data is not freed in the -EINVAL case.  (The 
code is below).

On failure of an init function, should the data accessible from a global 
variable be freed?  The loop also puts data in a list that also appears to 
be accessible from a global pointer.  Should that be freed as well?

Overall, it seems clear that when things are only referenced by local 
variables they should be cleaned up, but when they are referenced by 
global variables, it is less clear what to do.

thanks,
julia



static int acpi_tables_sysfs_init(void)
{
	struct acpi_table_attr *table_attr;
	struct acpi_table_header *table_header = NULL;
	int table_index = 0;
	int result;

	tables_kobj = kobject_create_and_add("tables", acpi_kobj);
	if (!tables_kobj)
		goto err;

	dynamic_tables_kobj = kobject_create_and_add("dynamic", tables_kobj);
	if (!dynamic_tables_kobj)
		goto err_dynamic_tables;

	do {
		result = acpi_get_table_by_index(table_index, &table_header);
		if (!result) {
			table_index++;
			table_attr = NULL;
			table_attr =
			    kzalloc(sizeof(struct acpi_table_attr), GFP_KERNEL);
			if (!table_attr)
				return -ENOMEM;

			acpi_table_attr_init(table_attr, table_header);
			result =
			    sysfs_create_bin_file(tables_kobj,
						  &table_attr->attr);
			if (result) {
				kfree(table_attr);
				return result;
			} else
				list_add_tail(&table_attr->node,
					      &acpi_table_attr_list);
		}
	} while (!result);
	kobject_uevent(tables_kobj, KOBJ_ADD);
	kobject_uevent(dynamic_tables_kobj, KOBJ_ADD);
	result = acpi_install_table_handler(acpi_sysfs_table_handler, NULL);

	return result == AE_OK ? 0 : -EINVAL;
err_dynamic_tables:
	kobject_put(tables_kobj);
err:
	return -ENOMEM;
}
