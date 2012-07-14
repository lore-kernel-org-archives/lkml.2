Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2GNLqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 07:46:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2GNLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 07:45:59 -0400
From: Jason Vas Dias <jason.vas.dias@gmail.com>
Reply-To: jason.vas.dias@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH: 1/1] ACPI: make evaluation of thermal trip points before  temperature or vice versa dependant on new "temp_b4_trip" module parameter to  support older AMD x86_64s
Date: Sat, 14 Jul 2012 12:45:44 +0100
User-Agent: KMail/1.12.4 (Linux/3.4.4-jvd+; KDE/4.3.4; x86_64; svn-1073138; 2010-01-11)
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Comrade DOS <suloevdmitry@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ovVAQvEhLeQRl0e"
Message-Id: <201207141245.44930.jason.vas.dias@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ovVAQvEhLeQRl0e
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

 This patch adds a new acpi.thermal.temp_b4_trip = 1 settting, which
 causes the temperature to be set before evaluation of thermal trip points (the old default) .
 This mode should be selected automatically by DMI match if the system identifies as 
  "HPCompaq 6715b" .
 Please consider applying a patch like that attached to fix the issue reported
 in lkml thread "Re: PROBLEM: Performance drop" recently,  whereby
 it was found that HP 6715b laptops ( which have 2.2Ghz dual-core  AMD
 x86_64 k8 CPUs) get stuck running the CPU at 800Khz and cannot switch frequency. 

 I have verified that this still the case with v3.4.4 tagged "stable" kernel. and with v3.5-rc6,
 which this is a patch against ( ie. against commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a :
 "Linux 3.5-rc6" :

diff --git a/Makefile b/Makefile                            
index 81ea154..bf02707 100644                               
--- a/Makefile                                              
+++ b/Makefile                                              
@@ -1,7 +1,7 @@                                             
 VERSION = 3                                                
 PATCHLEVEL = 5                                             
 SUBLEVEL = 0                                               
-EXTRAVERSION = -rc5                                        
+EXTRAVERSION = -rc6                                        
 NAME = Saber-toothed Squirrel                              
                                                            
 # *DOCUMENTATION*                                          
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 7dbebea..13d3b22 100644                               
--- a/drivers/acpi/thermal.c                                
+++ b/drivers/acpi/thermal.c                                
@@ -96,6 +96,10 @@ static int psv;                          
 module_param(psv, int, 0644);                              
 MODULE_PARM_DESC(psv, "Disable or override all passive trip points.");
                                                                       
+static bool temp_b4_trip;                                             
+module_param(temp_b4_trip, bool, 0644);                               
+MODULE_PARM_DESC(temp_b4_trip, "Get the temperature before initializing trip points.");
+                                                                                       
 static int acpi_thermal_add(struct acpi_device *device);                               
 static int acpi_thermal_remove(struct acpi_device *device, int type);                  
 static int acpi_thermal_resume(struct acpi_device *device);                            
@@ -941,27 +945,41 @@ static int acpi_thermal_get_info(struct acpi_thermal *tz)         
        if (!tz)                                                                        
                return -EINVAL;                                                         
                                                                                        
-       /* Get trip points [_CRT, _PSV, etc.] (required) */                             
-       result = acpi_thermal_get_trip_points(tz);                                      
-       if (result)                                                                     
+       if( temp_b4_trip )                                                              
+       { /* some CPUs, eg AMD K8 need temperature before trip points can be obtained */
+           /* Get temperature [_TMP] (required) */                                     
+           result = acpi_thermal_get_temperature(tz);                                  
+           if (result)                                                                 
                return result;                                                          
-                                                                                       
-       /* Get temperature [_TMP] (required) */                                         
-       result = acpi_thermal_get_temperature(tz);                                      
-       if (result)                                                                     
+                                                                                       
+           /* Get trip points [_CRT, _PSV, etc.] (required) */                         
+           result = acpi_thermal_get_trip_points(tz);                                  
+           if (result)                                                                 
                return result;                                                          
-                                                                                       
+       }else                                                                           
+       { /* newer x86_64s need trip points set before temperature obtained */          
+           /* Get trip points [_CRT, _PSV, etc.] (required) */                         
+           result = acpi_thermal_get_trip_points(tz);                                  
+           if (result)                                                                 
+               return result;                                                          
+                                                                                       
+           /* Get temperature [_TMP] (required) */                                     
+           result = acpi_thermal_get_temperature(tz);                                  
+           if (result)                                                                 
+               return result;                                                          
+       }                                                                               
+                                                                                       
        /* Set the cooling mode [_SCP] to active cooling (default) */                   
        result = acpi_thermal_set_cooling_mode(tz, ACPI_THERMAL_MODE_ACTIVE);
        if (!result)
                tz->flags.cooling_mode = 1;
-
+
        /* Get default polling frequency [_TZP] (optional) */
        if (tzp)
                tz->polling_frequency = tzp;
        else
                acpi_thermal_get_polling_frequency(tz);
-
+
        return 0;
 }

@@ -1110,6 +1128,14 @@ static int thermal_psv(const struct dmi_system_id *d) {
        return 0;
 }

+static int thermal_temp_b4_trip(const struct dmi_system_id *d) {
+
+       printk(KERN_NOTICE "ACPI: %s detected: : "
+                           "getting temperature before trip point initialisation\n", d->ident);
+       temp_b4_trip = TRUE;
+       return 0;
+}
+
 static struct dmi_system_id thermal_dmi_table[] __initdata = {
        /*
         * Award BIOS on this AOpen makes thermal control almost worthless.
@@ -1147,6 +1173,14 @@ static struct dmi_system_id thermal_dmi_table[] __initdata = {
                DMI_MATCH(DMI_BOARD_NAME, "7ZX"),
                },
        },
+       {
+        .callback = thermal_temp_b4_trip,
+        .ident = "HP 6715b laptop",
+        .matches = {
+                    DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+                    DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
+               },
+       },
        {}
 };




--Boundary-00=_ovVAQvEhLeQRl0e
Content-Type: text/x-patch;
  charset="ISO-8859-1";
  name="ACPI-Thermal-PROBLEM_performance_X86_64_K8.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ACPI-Thermal-PROBLEM_performance_X86_64_K8.patch"

diff --git a/Makefile b/Makefile
index 81ea154..bf02707 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 0
-EXTRAVERSION = -rc5
+EXTRAVERSION = -rc6
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 7dbebea..13d3b22 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -96,6 +96,10 @@ static int psv;
 module_param(psv, int, 0644);
 MODULE_PARM_DESC(psv, "Disable or override all passive trip points.");
 
+static bool temp_b4_trip;
+module_param(temp_b4_trip, bool, 0644);
+MODULE_PARM_DESC(temp_b4_trip, "Get the temperature before initializing trip points.");
+
 static int acpi_thermal_add(struct acpi_device *device);
 static int acpi_thermal_remove(struct acpi_device *device, int type);
 static int acpi_thermal_resume(struct acpi_device *device);
@@ -941,27 +945,41 @@ static int acpi_thermal_get_info(struct acpi_thermal *tz)
 	if (!tz)
 		return -EINVAL;
 
-	/* Get trip points [_CRT, _PSV, etc.] (required) */
-	result = acpi_thermal_get_trip_points(tz);
-	if (result)
+	if( temp_b4_trip )
+	{ /* some CPUs, eg AMD K8 need temperature before trip points can be obtained */
+	    /* Get temperature [_TMP] (required) */
+	    result = acpi_thermal_get_temperature(tz);
+	    if (result)
 		return result;
-
-	/* Get temperature [_TMP] (required) */
-	result = acpi_thermal_get_temperature(tz);
-	if (result)
+	    
+	    /* Get trip points [_CRT, _PSV, etc.] (required) */
+	    result = acpi_thermal_get_trip_points(tz);
+	    if (result)
 		return result;
-
+	}else
+	{ /* newer x86_64s need trip points set before temperature obtained */
+	    /* Get trip points [_CRT, _PSV, etc.] (required) */
+	    result = acpi_thermal_get_trip_points(tz);
+	    if (result)
+		return result;
+	    
+	    /* Get temperature [_TMP] (required) */
+	    result = acpi_thermal_get_temperature(tz);
+	    if (result)
+		return result;
+	}
+	
 	/* Set the cooling mode [_SCP] to active cooling (default) */
 	result = acpi_thermal_set_cooling_mode(tz, ACPI_THERMAL_MODE_ACTIVE);
 	if (!result)
 		tz->flags.cooling_mode = 1;
-
+	
 	/* Get default polling frequency [_TZP] (optional) */
 	if (tzp)
 		tz->polling_frequency = tzp;
 	else
 		acpi_thermal_get_polling_frequency(tz);
-
+	
 	return 0;
 }
 
@@ -1110,6 +1128,14 @@ static int thermal_psv(const struct dmi_system_id *d) {
 	return 0;
 }
 
+static int thermal_temp_b4_trip(const struct dmi_system_id *d) {
+
+	printk(KERN_NOTICE "ACPI: %s detected: : "
+                           "getting temperature before trip point initialisation\n", d->ident);
+	temp_b4_trip = TRUE;
+	return 0;
+}
+
 static struct dmi_system_id thermal_dmi_table[] __initdata = {
 	/*
 	 * Award BIOS on this AOpen makes thermal control almost worthless.
@@ -1147,6 +1173,14 @@ static struct dmi_system_id thermal_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_BOARD_NAME, "7ZX"),
 		},
 	},
+	{
+	 .callback = thermal_temp_b4_trip,
+	 .ident = "HP 6715b laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
+		},
+	},
 	{}
 };
 

--Boundary-00=_ovVAQvEhLeQRl0e--
