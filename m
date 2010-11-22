Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0KVPLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:11:22 -0500
Received: from ns1.wincor-nixdorf.com ([80.154.98.129]:54247 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab0KVPLV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:11:21 -0500
Message-ID: <4CEA8684.7060809@wincor-nixdorf.com>
Date: Mon, 22 Nov 2010 16:04:36 +0100
From: Frank Salomon <frank.salomon@wincor-nixdorf.com>
Reply-To: frank.salomon@wincor-nixdorf.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624 
    Netscape/7.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG 2.6.20.1] in drivers/usb/storage/scsiglue.c
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

please connect a memstick/pendrive to the usb port and try to read 
/proc/scsi/usb-storage/<#> in 2 ways:


int main ( int argc, char *argv[] )
{
	char c, buffer[20000];
	int fd, i;

	fd = open ( argv[1],  O_RDONLY, 0 );
	if ( fd >= 0 )
		{
		while ( read ( fd, &c , 1 ) > 0 )
			{
			write ( 1, &c, 1 );
			}
		close ( fd );
		}
	fd = open ( argv[1],  O_RDONLY, 0 );
	if ( fd >= 0 )
		{
		while ( (i = read ( fd, &buffer[0] , 20000 )) > 0 )
			{
			write ( 1, &buffer[0], i );
			}
		close ( fd );
		}
	
}

and you will get 2 results.


Error is in file drivers/usb/storage/scsiglue.c, macro SPRINTF. But we 
don't need the macro, because the buffer in 
fs/proc/generic.c:proc_file_read is one PAGE.
Solution is:

# diff -Naur linux_orig/drivers/usb/storage/scsiglue.c 
linux/drivers/usb/storage/scsiglue.c
--- linux_orig/drivers/usb/storage/scsiglue.c   2007-02-20 
07:34:32.000000000 +0100
+++ linux/drivers/usb/storage/scsiglue.c        2010-11-22 
17:13:16.000000000 +0100
@@ -329,25 +329,28 @@
  /***********************************************************************
   * /proc/scsi/ functions
   ***********************************************************************/
-
-/* we use this macro to help us write into the buffer */
+/*
+ * we use this macro to help us write into the buffer
+ *
  #undef SPRINTF
  #define SPRINTF(args...) \
         do { if (pos < buffer+length) pos += sprintf(pos, ## args); } 
while (0)
+*/

  static int proc_info (struct Scsi_Host *host, char *buffer,
                 char **start, off_t offset, int length, int inout)
  {
         struct us_data *us = host_to_us(host);
-       char *pos = buffer;
+       char *pos;
         const char *string;

         /* if someone is sending us data, just throw it away */
         if (inout)
                 return length;

+       pos = buffer;
         /* print the controller name */
-       SPRINTF("   Host scsi%d: usb-storage\n", host->host_no);
+       pos += sprintf ( pos, "   Host scsi%d: usb-storage\n", 
host->host_no);

         /* print product, vendor, and serial number strings */
         if (us->pusb_dev->manufacturer)
@@ -356,24 +359,27 @@
                 string = us->unusual_dev->vendorName;
         else
                 string = "Unknown";
-       SPRINTF("       Vendor: %s\n", string);
+       pos += sprintf ( pos, "       Vendor: %s\n", string);
+
         if (us->pusb_dev->product)
                 string = us->pusb_dev->product;
         else if (us->unusual_dev->productName)
                 string = us->unusual_dev->productName;
         else
                 string = "Unknown";
-       SPRINTF("      Product: %s\n", string);
+       pos += sprintf ( pos, "      Product: %s\n", string);
+
         if (us->pusb_dev->serial)
                 string = us->pusb_dev->serial;
         else
                 string = "None";
-       SPRINTF("Serial Number: %s\n", string);
+       pos += sprintf ( pos, "Serial Number: %s\n", string);

         /* show the protocol and transport */
-       SPRINTF("     Protocol: %s\n", us->protocol_name);
-       SPRINTF("    Transport: %s\n", us->transport_name);
+       pos += sprintf ( pos, "     Protocol: %s\n", us->protocol_name);

+       pos += sprintf ( pos, "    Transport: %s\n", us->transport_name);
+
         /* show the device flags */
         if (pos < buffer + length) {
                 pos += sprintf(pos, "       Quirks:");


Best regards, frank
(Please ignore the rest of this email)


WINCOR NIXDORF International GmbH
Sitz der Gesellschaft: Paderborn
Registergericht Paderborn HRB 3507
Geschäftsführer: Eckard Heidloff (Vorsitzender), Stefan Auerbach, Dr. Jürgen Wunram
Vorsitzender des Aufsichtsrats: Karl-Heinz Stiller
Steuernummer: 339/5884/0020 - Ust-ID Nr.: DE812927716 - WEEE-Reg.-Nr. DE44477193

Diese E-Mail enthält vertrauliche Informationen.
Wenn Sie nicht der richtige Adressat sind oder diese E-Mail irrtümlich erhalten haben,
informieren Sie bitte sofort den Absender und vernichten Sie diese E-Mail.
Das unerlaubte Kopieren sowie die unbefugte Weitergabe dieser E-Mail ist nicht gestattet.

This e-mail may contain confidential information.
If you are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail.
Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden.
