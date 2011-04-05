Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab1DESOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1DESOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:14:03 -0400
Date: Tue, 5 Apr 2011 14:14:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
        mikew@google.com, Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110405181401.16766.73248.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D9B4E3A.4090601@redhat.com>
References: <4D9B4E3A.4090601@redhat.com>
Subject: Re: /sys/firmware/dmi name change?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, this is what I was thinking of doing for 2.6.39.

P.

---8<---

sys/firmware/dmi should be sys/firmware/smbios.

commit 948af1f0bbc8526448e8cbe3f8d3bf211bdf5181
introduced a new firmware directory called /sys/firmware/dmi which
provides broken out SMBIOS entries for userspace.

In a previous discussion I've mentioned that it would be a good idea for
us to move away from using 'dmi' towards using 'smbios' and centralizing
the SMBIOS code that is scattered throughout the kernel.

Modified ('dmi' to 'smbios') and moved sysfs-firmware-dmi to
sysfs-firmware-smbios.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
deleted file mode 100644
index ba9da95..0000000
--- a/Documentation/ABI/testing/sysfs-firmware-dmi
+++ /dev/null
@@ -1,110 +0,0 @@
-What:		/sys/firmware/dmi/
-Date:		February 2011
-Contact:	Mike Waychison <mikew@google.com>
-Description:
-		Many machines' firmware (x86 and ia64) export DMI /
-		SMBIOS tables to the operating system.  Getting at this
-		information is often valuable to userland, especially in
-		cases where there are OEM extensions used.
-
-		The kernel itself does not rely on the majority of the
-		information in these tables being correct.  It equally
-		cannot ensure that the data as exported to userland is
-		without error either.
-
-		DMI is structured as a large table of entries, where
-		each entry has a common header indicating the type and
-		length of the entry, as well as 'handle' that is
-		supposed to be unique amongst all entries.
-
-		Some entries are required by the specification, but many
-		others are optional.  In general though, users should
-		never expect to find a specific entry type on their
-		system unless they know for certain what their firmware
-		is doing.  Machine to machine will vary.
-
-		Multiple entries of the same type are allowed.  In order
-		to handle these duplicate entry types, each entry is
-		assigned by the operating system an 'instance', which is
-		derived from an entry type's ordinal position.  That is
-		to say, if there are 'N' multiple entries with the same type
-		'T' in the DMI tables (adjacent or spread apart, it
-		doesn't matter), they will be represented in sysfs as
-		entries "T-0" through "T-(N-1)":
-
-		Example entry directories:
-
-			/sys/firmware/dmi/entries/17-0
-			/sys/firmware/dmi/entries/17-1
-			/sys/firmware/dmi/entries/17-2
-			/sys/firmware/dmi/entries/17-3
-			...
-
-		Instance numbers are used in lieu of the firmware
-		assigned entry handles as the kernel itself makes no
-		guarantees that handles as exported are unique, and
-		there are likely firmware images that get this wrong in
-		the wild.
-
-		Each DMI entry in sysfs has the common header values
-		exported as attributes:
-
-		handle	: The 16bit 'handle' that is assigned to this
-			  entry by the firmware.  This handle may be
-			  referred to by other entries.
-		length	: The length of the entry, as presented in the
-			  entry itself.  Note that this is _not the
-			  total count of bytes associated with the
-			  entry_.  This value represents the length of
-			  the "formatted" portion of the entry.  This
-			  "formatted" region is sometimes followed by
-			  the "unformatted" region composed of nul
-			  terminated strings, with termination signalled
-			  by a two nul characters in series.
-		raw	: The raw bytes of the entry. This includes the
-			  "formatted" portion of the entry, the
-			  "unformatted" strings portion of the entry,
-			  and the two terminating nul characters.
-		type	: The type of the entry.  This value is the same
-			  as found in the directory name.  It indicates
-			  how the rest of the entry should be
-			  interpreted.
-		instance: The instance ordinal of the entry for the
-			  given type.  This value is the same as found
-			  in the parent directory name.
-		position: The position of the entry within the entirety
-			  of the entirety.
-
-		=== Entry Specialization ===
-
-		Some entry types may have other information available in
-		sysfs.
-
-		--- Type 15 - System Event Log ---
-
-		This entry allows the firmware to export a log of
-		events the system has taken.  This information is
-		typically backed by nvram, but the implementation
-		details are abstracted by this table.  This entries data
-		is exported in the directory:
-
-		/sys/firmware/dmi/entries/15-0/system_event_log
-
-		and has the following attributes (documented in the
-		SMBIOS / DMI specification under "System Event Log (Type 15)":
-
-		area_length
-		header_start_offset
-		data_start_offset
-		access_method
-		status
-		change_token
-		access_method_address
-		header_format
-		per_log_type_descriptor_length
-		type_descriptors_supported_count
-
-		As well, the kernel exports the binary attribute:
-
-		raw_event_log	: The raw binary bits of the event log
-				  as described by the DMI entry.
diff --git a/Documentation/ABI/testing/sysfs-firmware-smbios b/Documentation/ABI/testing/sysfs-firmware-smbios
new file mode 100644
index 0000000..88b6067
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-smbios
@@ -0,0 +1,110 @@
+What:		/sys/firmware/smbios/
+Date:		February 2011
+Contact:	Mike Waychison <mikew@google.com>
+Description:
+		Many machines' firmware (x86 and ia64) export SMBIOS
+		structures to the operating system.  Getting at this
+		information is often valuable to userland, especially in
+		cases where there are OEM extensions used.
+
+		The kernel itself does not rely on the majority of the
+		information in these tables being correct.  It equally
+		cannot ensure that the data as exported to userland is
+		without error either.
+
+		SMBIOS is structured as a large table of entries, where
+		each entry has a common header indicating the type and
+		length of the entry, as well as 'handle' that is
+		supposed to be unique amongst all entries.
+
+		Some entries are required by the specification, but many
+		others are optional.  In general though, users should
+		never expect to find a specific entry type on their
+		system unless they know for certain what their firmware
+		is doing.  Machine to machine will vary.
+
+		Multiple entries of the same type are allowed.  In order
+		to handle these duplicate entry types, each entry is
+		assigned by the operating system an 'instance', which is
+		derived from an entry type's ordinal position.  That is
+		to say, if there are 'N' multiple entries with the same type
+		'T' in the SMBIOS tables (adjacent or spread apart, it
+		doesn't matter), they will be represented in sysfs as
+		entries "T-0" through "T-(N-1)":
+
+		Example entry directories:
+
+			/sys/firmware/smbios/entries/17-0
+			/sys/firmware/smbios/entries/17-1
+			/sys/firmware/smbios/entries/17-2
+			/sys/firmware/smbios/entries/17-3
+			...
+
+		Instance numbers are used in lieu of the firmware
+		assigned entry handles as the kernel itself makes no
+		guarantees that handles as exported are unique, and
+		there are likely firmware images that get this wrong in
+		the wild.
+
+		Each SMBIOS entry in sysfs has the common header values
+		exported as attributes:
+
+		handle	: The 16bit 'handle' that is assigned to this
+			  entry by the firmware.  This handle may be
+			  referred to by other entries.
+		length	: The length of the entry, as presented in the
+			  entry itself.  Note that this is _not the
+			  total count of bytes associated with the
+			  entry_.  This value represents the length of
+			  the "formatted" portion of the entry.  This
+			  "formatted" region is sometimes followed by
+			  the "unformatted" region composed of nul
+			  terminated strings, with termination signalled
+			  by a two nul characters in series.
+		raw	: The raw bytes of the entry. This includes the
+			  "formatted" portion of the entry, the
+			  "unformatted" strings portion of the entry,
+			  and the two terminating nul characters.
+		type	: The type of the entry.  This value is the same
+			  as found in the directory name.  It indicates
+			  how the rest of the entry should be
+			  interpreted.
+		instance: The instance ordinal of the entry for the
+			  given type.  This value is the same as found
+			  in the parent directory name.
+		position: The position of the entry within the entirety
+			  of the entirety.
+
+		=== Entry Specialization ===
+
+		Some entry types may have other information available in
+		sysfs.
+
+		--- Type 15 - System Event Log ---
+
+		This entry allows the firmware to export a log of
+		events the system has taken.  This information is
+		typically backed by nvram, but the implementation
+		details are abstracted by this table.  This entries data
+		is exported in the directory:
+
+		/sys/firmware/smbios/entries/15-0/system_event_log
+
+		and has the following attributes (documented in the
+		2.7.1 SMBIOS specification under "System Event Log (Type 15)":
+
+		area_length
+		header_start_offset
+		data_start_offset
+		access_method
+		status
+		change_token
+		access_method_address
+		header_format
+		per_log_type_descriptor_length
+		type_descriptors_supported_count
+
+		As well, the kernel exports the binary attribute:
+
+		raw_event_log	: The raw binary bits of the event log
+				  as described by the SMBIOS entry.
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index eb26d62..40d9825 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -652,7 +652,7 @@ static int __init dmi_sysfs_init(void)
 	int val;
 
 	/* Set up our directory */
-	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
+	dmi_kobj = kobject_create_and_add("smbios", firmware_kobj);
 	if (!dmi_kobj)
 		goto err;
 
