Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2KNAA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:00:57 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:43234 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab2KNAAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:00:55 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: multipart/mixed; boundary=Apple-Mail-6-881890762
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121113233049.GB32290@truffula.fritz.box>
Date: Wed, 14 Nov 2012 02:00:45 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Message-Id: <88F93258-5DD2-40BC-A95B-6B3916FC6518@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box> <BD20AE03-C138-4BC6-AE02-F162AF6840B2@antoniou-consulting.com> <20121113233049.GB32290@truffula.fritz.box>
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-6-881890762
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi David,

Since this is getting to be too long-winded I went ahead a coded=20
something quick and dirty.
=20
On Nov 14, 2012, at 1:30 AM, David Gibson wrote:

> On Tue, Nov 13, 2012 at 10:09:28AM +0200, Pantelis Antoniou wrote:
>> Hi David,
>>=20
>> On Nov 13, 2012, at 9:25 AM, David Gibson wrote:
>>=20
>>> On Mon, Nov 12, 2012 at 09:52:32AM -0700, Stephen Warren wrote:
>>>> On 11/12/2012 05:10 AM, Pantelis Antoniou wrote:
>>> [snip]
>>>>> Oh yes. In fact if one was to use a single kernel image for =
beagleboard
>>>>> and beaglebone, for the cape to work for both, it is required for =
it's
>>>>> dtb to be compatible.=20
>>>>=20
>>>> Well, as Grant pointed out, it's not actually strictly necessary =
for the
>>>> .dtb to be compatible; only the .dts /need/ be compatible, and the =
.dtb
>>>> can be generated at run-time using dtc for example.
>>>=20
>>> So, actually, I think a whole bunch of problems with phandle
>>> resolution disappear if we don't try to define an overlay .dtb =
format,
>>> or at least treat it only as a very shortlived object.  A more =
precise
>>> proposal below.  Note that this works more or less equally well with
>>> either the original overlay approach or the graft/graft-bundle
>>> proposal I made elsewhere.
>>>=20
>>> 1) We annotate the base tree with some extra label information for
>>> nodes which overlays are likely to want to reference by phandle.  =
e.g.
>>>=20
>>> 	beaglebone_pic: interrupt-controller@XXXXX {
>>> 		...
>>> 		phandle,symbolic-name =3D "beaglebone_pic";
>>> 	};
>>>=20
>>> We could extend dtc to (optionally?) auto-generate those properties
>>> from its existing label syntax.  Not sure if that's a good idea or
>>> not yet.  In any case, we compile this augmented base tree to .dtb =
as
>>> normal and boot our kernel with it.
>>>=20
>>=20
>> I'm fine with that. You can auto-generate when there's a label to a =
node.
>> The cape dt fragment will use the label name to reference a node.
>> More details below...
>>=20
>>> 2) The information for the capes/modules/whatever is
>>> distributed/packaged as .dts, never .dtb.  When userspace detects =
the
>>> new module (or the user explicitly tells it, if it's not probeable) =
it
>>> picks up the correct dts and runs it through dtc in a special mode.
>>> In this mode dtc takes the existing base tree (from =
/proc/device-tree,
>>> say) as well as the new dts.  In this mode, dtc allocates phandles =
for
>>> the new tree fragment so as not to collide with anything from the
>>> supplied base tree (as well as avoiding internal conflicts,
>>> obviously).  It also allows node references to the base tree by =
using
>>> those label annotations from (1) to match symbolic names to the
>>> phandle values in the base tree.
>>>=20
>>=20
>> Not good to rely on userspace kicking off dtc and compiling from =
source.
>> Some capes/expansion boards might have your root fs device, for =
example
>> there is an eMMC cape coming up, while networking capes are common =
too.
>=20
> So?  dtc can go in an initramfs, just like mdadm or whatever other
> tools are there.
>=20

Embedded systems aren't servers. Having an initramfs is one more thing =
that
can break, or require people to modify their build systems.

>> However I have a compromise.=20
>>=20
>> I agree that compiling from source can be an option for a runtime =
definable=20
>> cape, but for built-in capes we could do a bit better.
>>=20
>> In particular, I don't see any particular need to have a DT fragment
>> reference anything that dependent of the runtime device tree. It =
should
>> be possible to compile the DT fragment in kernel, against the =
generated
>> flattened device tree, producing a flattened DT fragment with the =
phandles
>> already resolved.
>=20
> Um..?  Sorry, I can't parse that paragraph.
>=20

No need for runtime resolution for common use cases.=20

>> So the sequence could be something like this:
>>=20
>> $ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts -@ =
${LAST_PHANDLE_FILE}
>> $ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 =
weather-cape.dts -@ ${LAST_PHANDLE_FILE}
>> $ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 =
geiger-cape.dts -@ ${LAST_PHANDLE_FILE}
>>=20
>> The ${LAST_PHANDLE_FILE} can be updated with the last phandle value =
generated.
>>=20
>> Alternatively we could have a way to statically assign a phandle =
range=20
>> for well known capes. All the others will have to use the runtime =
compile
>> mechanism.
>> $ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts
>> $ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 =
weather-cape.dts
>> $ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 =
geiger-cape.dts
>>=20
>> With the cape dtses having a /phandle-range/ statement at the top.
>>=20
>> This can work because the cape dts do not cross-reference each other, =
and
>> neither the boot dts references the capes.
>>=20
>> That way we can use request_firmware() pretty early in the boot =
sequence
>> and get the DT fragment we need even before user-space starts and =
root fs
>> has mounted. request_firmware() can locate the fragments in the =
kernel
>> image before rootfs.
>>=20
>> I don't know if this will cover all the cases Grant has in mind =
though.
>>=20
>> So just to make sure I got it right, this could work for our case.
>>=20
>> i2c2: i2c@4819c000 {
>> 	compatible =3D "ti,omap4-i2c";
>>        #address-cells =3D <1>;
>>        #size-cells =3D <0>;
>>        ti,hwmods =3D "i2c3";
>>        reg =3D <0x4819c000 0x1000>;
>>        interrupt-parent =3D <&intc>;
>>        interrupts =3D <30>;
>>        status =3D "disabled";
>> };
>>=20
>> And in the cape definition (when compiled with the special mode I =
describe
>> below)
>>=20
>> / {
>> 	plugin-bundle;
>> 	compatible =3D "cco,weather-cape";
>> 	version =3D <00A0>;
>>=20
>> 	i2c2-graft =3D {
>> 		compatible =3D <dt,graft>;
>> 		graft-point =3D <&i2c2>;
>> 	=09
>> 		#address-cells =3D <1>;
>>                #size-cells =3D <0>;
>>=20
>> 		/* Ambient light sensor */=20
>> 		tsl2550@39 {=20
>> 			compatible =3D "tsl,tsl2550";=20
>> 			reg =3D <0x39>;
>> 		}; =09
>> 	};
>> };
>>=20
>> DTC when compiling in the special fragment mode will pick up that
>> &i2c2 can not be resolved and lookup the phandle on the main dtb.
>> That way, even 'phandle,symbolic-name =3D "i2c2";' is redundant.
>=20
> Well, no, because I'm assuming dtc fragment mode only has access to
> the base dtb, not the base dts, so labels will be gone from it, unless
> we add properties to preserve them especially.  That's what the
> symbolic-name thing is about.
>=20

They can be easily included, as the patch shows.

>>> 3) The resulting partial .dtb for the module is highly specific to =
the
>>> base tree (which if the base tree was generated at runtime by =
firmware
>>> could even be specific to a particular boot).  But that's ok, =
because
>>> we just spit it into the kernel, absolute phandle values and all, =
then
>>> throw it away.  Next time we need the module info, we recompile it
>>> again.
>>>=20
>>>> Of course, relying on .dts compatibility rather than .dtb =
compatibility
>>>> might negatively impact the complexity of an initrd environment if =
we
>>>> end up loading overlays from there...
>>>=20
>>> Well, it does mean we'd need dtc in the initrd.  But dtc has no
>>> library dependencies except libc, so that really shouldn't be too
>>> bad.  In return we entirely avoid inventing a new phandle resolution
>>> protocol.
>>=20
>> Not every board boots with initrd; most embedded boards don't use it
>> at all. This way we make initrd a hard requirement.
>=20
> Well, not really.  You can use initramfs, or you can assemble all the
> necessary dt fragents for boot into a complete dtb included with the
> kernel.  Doing that involves pretty much the same sorts of things you
> need to do to statically configure a kernel for boot without
> initramfs.
>=20


You can't assemble the dtb without runtime probing of what's out there.

> --=20
> David Gibson			| I'll have my music baroque, and my =
code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT =
_the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson

Anyway, here's a small patch that shows that it is possible to do both =
fixups
and symbol tracking using relatively unmodified DT syntax. The only =
thing
new is the /plugin/; statement.

Also included two dumps of generated dtbs as well as the plugin dts.

Should be relatively simple to come up with a kernel loader and linker =
using
something similar like this.

Regards=20

-- Pantelis



--Apple-Mail-6-881890762
Content-Disposition: attachment;
	filename=dtc-symbols-fixups-test.patch
Content-Type: application/octet-stream;
	name="dtc-symbols-fixups-test.patch"
Content-Transfer-Encoding: 7bit

commit 874ee3c0dceaf2735ebb82b4ad117108b6d2125b
Author: Pantelis Antoniou <panto@antoniou-consulting.com>
Date:   Wed Nov 14 23:40:59 2012 +0200

    Implement fixups and symbols
    
    Introduce symbols and a fixup nodes in the root tree.

diff --git a/checks.c b/checks.c
index ee96a25..b1b87ed 100644
--- a/checks.c
+++ b/checks.c
@@ -459,20 +459,73 @@ static void fixup_phandle_references(struct check *c, struct node *dt,
 	struct marker *m = prop->val.markers;
 	struct node *refnode;
 	cell_t phandle;
+	int has_phandle_refs;
+
+	has_phandle_refs = 0;
+	for_each_marker_of_type(m, REF_PHANDLE) {
+		has_phandle_refs = 1;
+		break;
+	}
+
+	if (!has_phandle_refs)
+		return;
 
 	for_each_marker_of_type(m, REF_PHANDLE) {
 		assert(m->offset + sizeof(cell_t) <= prop->val.len);
 
 		refnode = get_node_by_ref(dt, m->ref);
-		if (! refnode) {
+		if (! refnode && !dt->is_plugin) {
 			FAIL(c, "Reference to non-existent node or label \"%s\"\n",
-			     m->ref);
+				m->ref);
 			continue;
 		}
 
-		phandle = get_node_phandle(dt, refnode);
+		if (! refnode) {
+			struct fixup *f, **fp;
+			struct fixup_entry *fe, **fep;
+
+			/* allocate fixup entry */
+			fe = xmalloc(sizeof(*fe));
+
+			fe->node = node;
+			fe->prop = prop;
+			fe->offset = m->offset;
+			fe->next = NULL;
+
+			/* search for an already existing fixup */
+			for_each_fixup(dt, f)
+				if (strcmp(f->ref, m->ref) == 0)
+					break;
+
+			/* no fixup found, add new */
+			if (f == NULL) {
+				f = xmalloc(sizeof(*f));
+				f->ref = m->ref;
+				f->entries = NULL;
+				f->next = NULL;
+
+				/* add it to the tree */
+				fp = &dt->fixups;
+				while (*fp)
+					fp = &((*fp)->next);
+				*fp = f;
+			}
+
+			/* and now append fixup entry */
+			fep = &f->entries;
+			while (*fep)
+				fep = &((*fep)->next);
+			*fep = fe;
+
+			/* mark the entry as unresolved */
+			phandle = 0xdeadbeef;
+		} else {
+			phandle = get_node_phandle(dt, refnode);
+		}
+
 		*((cell_t *)(prop->val.val + m->offset)) = cpu_to_fdt32(phandle);
 	}
+
 }
 ERROR(phandle_references, NULL, NULL, fixup_phandle_references, NULL,
       &duplicate_node_names, &explicit_phandles);
@@ -651,6 +704,42 @@ static void check_obsolete_chosen_interrupt_controller(struct check *c,
 }
 TREE_WARNING(obsolete_chosen_interrupt_controller, NULL);
 
+static void check_auto_label_phandles(struct check *c, struct node *dt,
+				       struct node *node)
+{
+	struct label *l;
+	struct symbol *s, **sp;
+	int has_label;
+
+	has_label = 0;
+	for_each_label(node->labels, l) {
+		has_label = 1;
+		break;
+	}
+
+	if (!has_label)
+		return;
+
+	/* force allocation of a phandle for this node */
+	(void)get_node_phandle(dt, node);
+
+	/* add the symbol */
+	for_each_label(node->labels, l) {
+
+		s = xmalloc(sizeof(*s));
+		s->label = l;
+		s->node = node;
+		s->next = NULL;
+
+		/* add it to the symbols list */
+		sp = &dt->symbols;
+		while (*sp)
+			sp = &((*sp)->next);
+		*sp = s;
+	}
+}
+NODE_WARNING(auto_label_phandles, NULL);
+
 static struct check *check_table[] = {
 	&duplicate_node_names, &duplicate_property_names,
 	&node_name_chars, &node_name_format, &property_name_chars,
@@ -669,6 +758,8 @@ static struct check *check_table[] = {
 	&avoid_default_addr_size,
 	&obsolete_chosen_interrupt_controller,
 
+	&auto_label_phandles,
+
 	&always_fail,
 };
 
diff --git a/dtc-lexer.l b/dtc-lexer.l
index 254d5af..2cef406 100644
--- a/dtc-lexer.l
+++ b/dtc-lexer.l
@@ -112,6 +112,11 @@ static int pop_input_file(void);
 			return DT_V1;
 		}
 
+<*>"/plugin/"	{
+			DPRINT("Keyword: /plugin/\n");
+			return DT_PLUGIN;
+		}
+
 <*>"/memreserve/"	{
 			DPRINT("Keyword: /memreserve/\n");
 			BEGIN_DEFAULT();
diff --git a/dtc-parser.y b/dtc-parser.y
index f412460..e444acf 100644
--- a/dtc-parser.y
+++ b/dtc-parser.y
@@ -20,6 +20,7 @@
 
 %{
 #include <stdio.h>
+#include <inttypes.h>
 
 #include "dtc.h"
 #include "srcpos.h"
@@ -56,9 +57,11 @@ static unsigned char eval_char_literal(const char *s);
 	struct node *nodelist;
 	struct reserve_info *re;
 	uint64_t integer;
+	int is_plugin;
 }
 
 %token DT_V1
+%token DT_PLUGIN
 %token DT_MEMRESERVE
 %token DT_LSHIFT DT_RSHIFT DT_LE DT_GE DT_EQ DT_NE DT_AND DT_OR
 %token DT_BITS
@@ -76,6 +79,7 @@ static unsigned char eval_char_literal(const char *s);
 
 %type <data> propdata
 %type <data> propdataprefix
+%type <is_plugin> plugindecl
 %type <re> memreserve
 %type <re> memreserves
 %type <array> arrayprefix
@@ -106,10 +110,23 @@ static unsigned char eval_char_literal(const char *s);
 %%
 
 sourcefile:
-	  DT_V1 ';' memreserves devicetree
+	  DT_V1 ';' plugindecl memreserves devicetree
 		{
-			the_boot_info = build_boot_info($3, $4,
-							guess_boot_cpuid($4));
+			$5->is_plugin = $3;
+			$5->is_root = 1;
+			the_boot_info = build_boot_info($4, $5,
+							guess_boot_cpuid($5));
+		}
+	;
+
+plugindecl:
+	/* empty */
+		{
+			$$ = 0;
+		}
+	| DT_PLUGIN ';'
+		{
+			$$ = 1;
 		}
 	;
 
diff --git a/dtc.h b/dtc.h
index 3e42a07..2659142 100644
--- a/dtc.h
+++ b/dtc.h
@@ -133,6 +133,25 @@ struct label {
 	struct label *next;
 };
 
+struct fixup_entry {
+	int offset;
+	struct node *node;
+	struct property *prop;
+	struct fixup_entry *next;
+};
+
+struct fixup {
+	char *ref;
+	struct fixup_entry *entries;
+	struct fixup *next;
+};
+
+struct symbol {
+	struct label *label;
+	struct node *node;
+	struct symbol *next;
+};
+
 struct property {
 	int deleted;
 	char *name;
@@ -159,6 +178,11 @@ struct node {
 	int addr_cells, size_cells;
 
 	struct label *labels;
+
+	int is_root;
+	int is_plugin;
+	struct fixup *fixups;
+	struct symbol *symbols;
 };
 
 #define for_each_label_withdel(l0, l) \
@@ -182,6 +206,15 @@ struct node {
 	for_each_child_withdel(n, c) \
 		if (!(c)->deleted)
 
+#define for_each_fixup(n, f) \
+	for ((f) = (n)->fixups; (f); (f) = (f)->next)
+
+#define for_each_fixup_entry(f, fe) \
+	for ((fe) = (f)->entries; (fe); (fe) = (fe)->next)
+
+#define for_each_symbol(n, s) \
+	for ((s) = (n)->symbols; (s); (s) = (s)->next)
+
 void add_label(struct label **labels, char *label);
 void delete_labels(struct label **labels);
 
diff --git a/fdtdump.c b/fdtdump.c
index 207a46d..d4fa6d7 100644
--- a/fdtdump.c
+++ b/fdtdump.c
@@ -21,13 +21,23 @@ static void print_data(const char *data, int len)
 {
 	int i;
 	const char *p = data;
+	const char *s;
 
 	/* no data, don't print */
 	if (len == 0)
 		return;
 
 	if (util_is_printable_string(data, len)) {
-		printf(" = \"%s\"", (const char *)data);
+		printf(" = ");
+
+		s = data;
+		do {
+			printf("\"%s\"", s);
+			s += strlen(s) + 1;
+			if (s < data + len)
+				printf(", ");
+		} while (s < data + len);
+
 	} else if ((len % 4) == 0) {
 		printf(" = <");
 		for (i = 0; i < len; i += 4)
diff --git a/flattree.c b/flattree.c
index 665dad7..f250672 100644
--- a/flattree.c
+++ b/flattree.c
@@ -310,6 +310,81 @@ static void flatten_tree(struct node *tree, struct emitter *emit,
 		flatten_tree(child, emit, etarget, strbuf, vi);
 	}
 
+	/* add the symbol nodes */
+	if (tree->is_root) {
+		struct symbol *s;
+		int nameoff, vallen;
+
+		emit->beginnode(etarget, NULL);
+		emit->string(etarget, "@symbols@", 0);
+		emit->align(etarget, sizeof(cell_t));
+
+		for_each_symbol(tree, s) {
+
+			vallen = strlen(s->node->fullpath);
+
+			nameoff = stringtable_insert(strbuf, s->label->label);
+
+			emit->property(etarget, NULL);
+			emit->cell(etarget, vallen + 1);
+			emit->cell(etarget, nameoff);
+
+			if ((vi->flags & FTF_VARALIGN) && vallen >= 8)
+				emit->align(etarget, 8);
+
+			emit->string(etarget, s->node->fullpath, strlen(s->node->fullpath));
+			emit->align(etarget, sizeof(cell_t));
+		}
+
+		emit->endnode(etarget, NULL);
+	}
+
+	/* add the fixup nodes */
+	if (tree->is_root && tree->is_plugin) {
+		struct fixup *f;
+		struct fixup_entry *fe;
+		char *name, *s;
+		int namesz, nameoff, vallen;
+
+		emit->beginnode(etarget, NULL);
+		emit->string(etarget, "@fixups@", 0);
+		emit->align(etarget, sizeof(cell_t));
+
+		for_each_fixup(tree, f) {
+
+			namesz = 0;
+			for_each_fixup_entry(f, fe)
+				namesz += strlen(fe->node->fullpath) + 1 +
+					  strlen(fe->prop->name) + 1 + 32;
+
+			name = xmalloc(namesz);
+
+			s = name;
+			for_each_fixup_entry(f, fe) {
+				snprintf(s, name + namesz - s, "%s:%s:%d",
+						fe->node->fullpath, fe->prop->name, fe->offset);
+				s += strlen(s) + 1;
+			}
+
+			nameoff = stringtable_insert(strbuf, f->ref);
+			vallen = s - name;
+
+			emit->property(etarget, NULL);
+			emit->cell(etarget, vallen);
+			emit->cell(etarget, nameoff);
+
+			if ((vi->flags & FTF_VARALIGN) && vallen >= 8)
+				emit->align(etarget, 8);
+
+			emit->string(etarget, name, vallen);
+			emit->align(etarget, sizeof(cell_t));
+
+			free(name);
+		}
+
+		emit->endnode(etarget, tree->labels);
+	}
+
 	emit->endnode(etarget, tree->labels);
 }
 

--Apple-Mail-6-881890762
Content-Disposition: attachment;
	filename=geiger-cape.fdtdump
Content-Type: application/octet-stream;
	name="geiger-cape.fdtdump"
Content-Transfer-Encoding: 7bit

/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x577 (1399)
// off_dt_struct:	0x38
// off_dt_strings:	0x440
// off_mem_rsvmap:	0x28
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0x137
// size_dt_struct:	0x408

/ {
    compatible = "bone-geiger-cape";
    board-name = "Geiger Cape";
    version = "00A0", "00A1", "00A2";
    pinctrl-names = "default";
    pinctrl-0 = <0xdeadbeef>;
    pwms = <0xdeadbeef 0x00000000 0x0007a120 0x00000000>;
    pwm-names = "bone-geiger-cape";
    pwm-frequency = <0x00004e20>;
    pwm-duty-cycle = <0x0000003c>;
    event-blink-delay = <0x0000001e>;
    gpios = <0xdeadbeef 0x00000011 0x00000000>;
    vsense-name = "AIN5";
    vsense-scale = <0x000091cd>;
    tscadc {
        compatible = "ti-tscadc-dt";
        ti,hwmods = "adc_tsc";
        adc-channels = <0x00000008>;
        linux,phandle = <0x00000001>;
        phandle = <0x00000001>;
    };
    gpio-leds {
        compatible = "gpio-leds";
        pinctrl-names = "default";
        pinctrl-0 = <0xdeadbeef>;
        linux,phandle = <0x00000002>;
        phandle = <0x00000002>;
        geiger-led0 {
            label = "geiger:green:usr0";
            gpios = <0xdeadbeef 0x00000017 0x00000000>;
            linux,default-trigger = "geiger-run";
            default-state = "off";
        };
        geiger-led1 {
            label = "geiger:red:usr1";
            gpios = <0xdeadbeef 0x00000019 0x00000000>;
            linux,default-trigger = "geiger-event";
            default-state = "off";
        };
    };
    @fixups@ {
        bone_geiger_cape_pins = "/:pinctrl-0:0";
        ehrpwm1 = "/:pwms:0";
        gpio4 = "/:gpios:0";
        bone_geiger_cape_led_pins = "/gpio-leds:pinctrl-0:0";
        gpio3 = "/gpio-leds/geiger-led0:gpios:0", "/gpio-leds/geiger-led1:gpios:0";
    };
    @symbols@ {
        tscadc = "/tscadc";
        gpioleds1 = "/gpio-leds";
    };
};

--Apple-Mail-6-881890762
Content-Disposition: attachment;
	filename=geiger-cape.dts
Content-Type: application/octet-stream;
	name="geiger-cape.dts"
Content-Transfer-Encoding: 7bit

/*
 * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
/dts-v1/;
/plugin/;

/ {
	compatible = "bone-geiger-cape";

	board-name = "Geiger Cape";
	version = "00A0", "00A1", "00A2";


	/* note that these can't be versioned... */
	pinctrl-names = "default";
	pinctrl-0 = <&bone_geiger_cape_pins>;

	pwms = <&ehrpwm1 0 500000 0>;
	pwm-names = "bone-geiger-cape";

	pwm-frequency  = <20000>;	/* 20KHz */
	pwm-duty-cycle = <60>;		/* 60% */

	event-blink-delay = <30>;	/* 30ms */

	gpios = <&gpio4 17 0>;		/* pulse */

	vsense-name = "AIN5";		/* analog vsense */
	vsense-scale = <37325>;		/* scaling */

	tscadc: tscadc {
		compatible = "ti-tscadc-dt";

		ti,hwmods = "adc_tsc";

		adc-channels = <8>;
	};

	gpioleds1: gpio-leds {
		compatible = "gpio-leds";
		pinctrl-names = "default";
		pinctrl-0 = <&bone_geiger_cape_led_pins>;

		geiger-led0 {
			label = "geiger:green:usr0";
			gpios = <&gpio3 23 0>;
			linux,default-trigger = "geiger-run";
			default-state = "off";
		};

		geiger-led1 {
			label = "geiger:red:usr1";
			gpios = <&gpio3 25 0>;
			linux,default-trigger = "geiger-event";
			default-state = "off";
		};
	};

};

--Apple-Mail-6-881890762
Content-Disposition: attachment;
	filename=am335x-bone.fdtdump
Content-Type: application/octet-stream;
	name="am335x-bone.fdtdump"
Content-Transfer-Encoding: quoted-printable

/dts-v1/;=0A//=20magic:=09=090xd00dfeed=0A//=20totalsize:=09=090x5de6=20=
(24038)=0A//=20off_dt_struct:=090x38=0A//=20off_dt_strings:=090x546c=0A=
//=20off_mem_rsvmap:=090x28=0A//=20version:=09=0917=0A//=20=
last_comp_version:=0916=0A//=20boot_cpuid_phys:=090x0=0A//=20=
size_dt_strings:=090x97a=0A//=20size_dt_struct:=090x5434=0A=0A/=20{=0A=20=
=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20#size-cells=20=
=3D=20<0x00000001>;=0A=20=20=20=20compatible=20=3D=20"ti,am335x-bone",=20=
"ti,am33xx";=0A=20=20=20=20model=20=3D=20"TI=20AM335x=20BeagleBone";=0A=20=
=20=20=20chosen=20{=0A=20=20=20=20};=0A=20=20=20=20aliases=20{=0A=20=20=20=
=20=20=20=20=20serial0=20=3D=20"/ocp/serial@44e09000";=0A=20=20=20=20=20=20=
=20=20serial1=20=3D=20"/ocp/serial@48022000";=0A=20=20=20=20=20=20=20=20=
serial2=20=3D=20"/ocp/serial@48024000";=0A=20=20=20=20=20=20=20=20=
serial3=20=3D=20"/ocp/serial@481a6000";=0A=20=20=20=20=20=20=20=20=
serial4=20=3D=20"/ocp/serial@481a8000";=0A=20=20=20=20=20=20=20=20=
serial5=20=3D=20"/ocp/serial@481aa000";=0A=20=20=20=20};=0A=20=20=20=20=
memory=20{=0A=20=20=20=20=20=20=20=20device_type=20=3D=20"memory";=0A=20=20=
=20=20=20=20=20=20reg=20=3D=20<0x80000000=200x10000000>;=0A=20=20=20=20=
};=0A=20=20=20=20cpus=20{=0A=20=20=20=20=20=20=20=20cpu@0=20{=0A=20=20=20=
=20=20=20=20=20=20=20=20=20compatible=20=3D=20"arm,cortex-a8";=0A=20=20=20=
=20=20=20=20=20=20=20=20=20operating-points=20=3D=20<0x000afc80=20=
0x00139b88=200x000927c0=200x0012b128=200x0007a120=200x00112a88=20=
0x00043238=200x00112a88>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
voltage-tolerance=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20clock-latency=20=3D=20<0x000493e0>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20cpu0-supply=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20};=0A=20=20=20=20soc=20{=0A=20=20=20=20=20=20=20=20compatible=20=3D=20=
"ti,omap-infra";=0A=20=20=20=20=20=20=20=20mpu=20{=0A=20=20=20=20=20=20=20=
=20=20=20=20=20compatible=20=3D=20"ti,omap3-mpu";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20ti,hwmods=20=3D=20"mpu";=0A=20=20=20=20=20=20=20=20};=0A=20=
=20=20=20};=0A=20=20=20=20pinmux@44e10800=20{=0A=20=20=20=20=20=20=20=20=
compatible=20=3D=20"pinctrl-single";=0A=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x44e10800=200x00000238>;=0A=20=20=20=20=20=20=20=20#address-cells=20=3D=20=
<0x00000001>;=0A=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20pinctrl-single,register-width=20=
=3D=20<0x00000020>;=0A=20=20=20=20=20=20=20=20=
pinctrl-single,function-mask=20=3D=20<0x0000007f>;=0A=20=20=20=20=20=20=20=
=20linux,phandle=20=3D=20<0x00000022>;=0A=20=20=20=20=20=20=20=20phandle=20=
=3D=20<0x00000022>;=0A=20=20=20=20=20=20=20=20pinmux_spi1_pins=20{=0A=20=20=
=20=20=20=20=20=20=20=20=20=20pinctrl-single,pins=20=3D=20<0x00000190=20=
0x00000013=200x00000194=200x00000033=200x00000198=200x00000013=20=
0x0000019c=200x00000013>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000008>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000008>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20pinmux_lcd_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x000001a4=200x00000017=200x000001ac=20=
0x00000017>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000021>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000021>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_gpevt_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x00000090=200x00000037>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000000b>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20phandle=20=3D=20<0x0000000b>;=0A=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20pinmux_userled_pins=20{=0A=20=20=20=20=20=20=
=20=20=20=20=20=20pinctrl-single,pins=20=3D=20<0x00000054=200x00000007=20=
0x00000058=200x00000017=200x0000005c=200x00000007=200x00000060=20=
0x00000017>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000009>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000009>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_i2c2_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x00000178=200x00000073=200x0000017c=20=
0x00000073>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000003>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_bone_dvi_cape_led_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x00000048=200x00000007=200x0000004c=20=
0x00000007>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000013>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000013>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_bone_dvi_cape_dvi_00A0_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20pinctrl-single,pins=20=3D=20<0x0000001c=200x00000007=200x000000a0=20=
0x00000008=200x000000a4=200x00000008=200x000000a8=200x00000008=20=
0x000000ac=200x00000008=200x000000b0=200x00000008=200x000000b4=20=
0x00000008=200x000000b8=200x00000008=200x000000bc=200x00000008=20=
0x000000c0=200x00000008=200x000000c4=200x00000008=200x000000c8=20=
0x00000008=200x000000cc=200x00000008=200x000000d0=200x00000008=20=
0x000000d4=200x00000008=200x000000d8=200x00000008=200x000000dc=20=
0x00000008=200x000000e0=200x00000000=200x000000e4=200x00000000=20=
0x000000e8=200x00000000=200x000000ec=200x00000000>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20linux,phandle=20=3D=20<0x00000011>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20phandle=20=3D=20<0x00000011>;=0A=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20pinmux_bone_dvi_cape_dvi_00A1_pins=20{=0A=20=
=20=20=20=20=20=20=20=20=20=20=20pinctrl-single,pins=20=3D=20<0x00000084=20=
0x00000007=200x000000a0=200x00000008=200x000000a4=200x00000008=20=
0x000000a8=200x00000008=200x000000ac=200x00000008=200x000000b0=20=
0x00000008=200x000000b4=200x00000008=200x000000b8=200x00000008=20=
0x000000bc=200x00000008=200x000000c0=200x00000008=200x000000c4=20=
0x00000008=200x000000c8=200x00000008=200x000000cc=200x00000008=20=
0x000000d0=200x00000008=200x000000d4=200x00000008=200x000000d8=20=
0x00000008=200x000000dc=200x00000008=200x000000e0=200x00000000=20=
0x000000e4=200x00000000=200x000000e8=200x00000000=200x000000ec=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000012>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000012>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_bone_geiger_cape_led_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x000000e4=200x00000007=200x000000ec=20=
0x00000007>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000017>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000017>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_bone_geiger_cape_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x00000048=200x00000006=200x0000019c=20=
0x00000037>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000014>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000014>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_bone_lcd3_cape_led_00A0_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20pinctrl-single,pins=20=3D=20<0x00000048=200x00000007=200x0000004c=20=
0x00000007>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x0000001a>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x0000001a>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
pinmux_bone_lcd3_cape_lcd_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-single,pins=20=3D=20<0x000000a0=200x00000008=200x000000a4=20=
0x00000008=200x000000a8=200x00000008=200x000000ac=200x00000008=20=
0x000000b0=200x00000008=200x000000b4=200x00000008=200x000000b8=20=
0x00000008=200x000000bc=200x00000008=200x000000c0=200x00000008=20=
0x000000c4=200x00000008=200x000000c8=200x00000008=200x000000cc=20=
0x00000008=200x000000d0=200x00000008=200x000000d4=200x00000008=20=
0x000000d8=200x00000008=200x000000dc=200x00000008=200x000000e0=20=
0x00000000=200x000000e4=200x00000000=200x000000e8=200x00000000=20=
0x000000ec=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000018>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000018>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20pinmux_bone_lcd3_cape_keys_00A0_pins=20{=0A=20=20=20=20=20=20=
=20=20=20=20=20=20pinctrl-single,pins=20=3D=20<0x00000040=200x0000002f=20=
0x00000044=200x0000002f=200x000001a4=200x0000002f=200x00000078=20=
0x0000002f=200x00000164=200x0000002f>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20linux,phandle=20=3D=20<0x0000001b>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20phandle=20=3D=20<0x0000001b>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=
=20=20=20=20=20pinmux_pwm_bl_pins=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20pinctrl-single,pins=20=3D=20<0x0000004c=200x00000006>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000001f>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20phandle=20=3D=20<0x0000001f>;=0A=20=20=20=20=20=20=20=
=20};=0A=20=20=20=20=20=20=20=20pinmux_weather_cape_w1_pins=20{=0A=20=20=20=
=20=20=20=20=20=20=20=20=20pinctrl-single,pins=20=3D=20<0x0000000c=20=
0x00000037>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x0000001e>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x0000001e>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20};=0A=20=20=20=20=
ocp=20{=0A=20=20=20=20=20=20=20=20compatible=20=3D=20"simple-bus";=0A=20=20=
=20=20=20=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=
=20=20#size-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=
ranges;=0A=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"l3_main";=0A=20=20=20=
=20=20=20=20=20interrupt-controller@48200000=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20compatible=20=3D=20"ti,omap2-intc";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20interrupt-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#interrupt-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20ti,intc-size=20=3D=20<0x00000080>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x48200000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20linux,phandle=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20phandle=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20edma@49000000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,edma3";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"tpcc",=20"tptc0",=20"tptc1",=20"tptc2";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20reg=20=3D=20<0x49000000=200x00010000=20=
0x44e10f90=200x00000010>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20interrupts=20=3D=20<0x0000000c=200x0000000d=200x0000000e>;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20#dma-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20dma-channels=20=3D=20<0x00000040>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20ti,edma-regions=20=3D=20<0x00000004>;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20ti,edma-slots=20=3D=20<0x00000100>;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20ti,edma-reserved-channels=20=3D=20<0x00000000=20=
0x00000002=200x0000000e=200x00000002=200x0000001a=200x00000006=20=
0x00000030=200x00000004=200x00000038=200x00000008>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20ti,edma-reserved-slots=20=3D=20<0x00000000=200x00000002=20=
0x0000000e=200x00000002=200x0000001a=200x00000006=200x00000030=20=
0x00000004=200x00000038=200x00000008=200x00000040=200x0000007f>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20ti,edma-queue-tc-map=20=3D=20<0x00000000=20=
0x00000000=200x00000001=200x00000001=200x00000002=200x00000002>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20ti,edma-queue-priority-map=20=3D=20=
<0x00000000=200x00000000=200x00000001=200x00000001=200x00000002=20=
0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,edma-default-queue=20=
=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,edma-xbar-event-map=20=3D=20<0x00000020=200x0000000c>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x00000004>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20phandle=20=3D=20<0x00000004>;=0A=20=20=20=20=20=20=20=
=20};=0A=20=20=20=20=20=20=20=20gpio@44e07000=20{=0A=20=20=20=20=20=20=20=
=20=20=20=20=20compatible=20=3D=20"ti,omap4-gpio";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20ti,hwmods=20=3D=20"gpio1";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20gpio-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20#gpio-cells=20=
=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#interrupt-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x44e07000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x00000060>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20linux,phandle=20=3D=20<0x0000001c>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20phandle=20=3D=20<0x0000001c>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20gpio@4804c000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap4-gpio";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"gpio2";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
gpio-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20#gpio-cells=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#interrupt-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x4804c000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x00000062>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20linux,phandle=20=3D=20<0x0000000a>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20phandle=20=3D=20<0x0000000a>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20gpio@481ac000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap4-gpio";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"gpio3";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
gpio-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20#gpio-cells=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#interrupt-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x481ac000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x00000020>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20linux,phandle=20=3D=20<0x0000000c>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20phandle=20=3D=20<0x0000000c>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20gpio@481ae000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap4-gpio";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"gpio4";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
gpio-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20#gpio-cells=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-controller;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#interrupt-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x481ae000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x0000003e>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20linux,phandle=20=3D=20<0x00000016>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20phandle=20=3D=20<0x00000016>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20serial@44e09000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20compatible=20=3D=20"ti,omap3-uart";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20ti,hwmods=20=3D=20"uart1";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x02dc6c00>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x44e09000=200x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x00000048>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"okay";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000023>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000023>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20serial@48022000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap3-uart";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"uart2";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x02dc6c00>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x48022000=200x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x00000049>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000024>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000024>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20serial@48024000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap3-uart";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"uart3";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x02dc6c00>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x48024000=200x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x0000004a>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000025>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000025>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20serial@481a6000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap3-uart";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"uart4";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x02dc6c00>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x481a6000=200x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x0000002c>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000026>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000026>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20serial@481a8000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap3-uart";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"uart5";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x02dc6c00>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x481a8000=200x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x0000002d>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000027>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000027>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20serial@481aa000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap3-uart";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"uart6";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x02dc6c00>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x481aa000=200x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x0000002e>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000028>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000028>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20i2c@44e0b000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap4-i2c";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#size-cells=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"i2c1";=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x44e0b000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20interrupts=20=3D=20<0x00000046>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
status=20=3D=20"okay";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
clock-frequency=20=3D=20<0x00061a80>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20linux,phandle=20=3D=20<0x00000029>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20phandle=20=3D=20<0x00000029>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
tps@24=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000024>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,tps65217";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20linux,phandle=20=3D=20<0x00000019>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20phandle=20=3D=20<0x00000019>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20regulators=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20regulator@0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20reg=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-compatible=20=3D=20=
"dcdc1";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20regulator-always-on;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000002a>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x0000002a>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20regulator@1=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-compatible=20=
=3D=20"dcdc2";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20regulator-name=20=3D=20"vdd_mpu";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-min-microvolt=20=
=3D=20<0x000e1d48>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20regulator-max-microvolt=20=3D=20<0x001437c8>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
regulator-boot-on;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20regulator-always-on;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20phandle=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20regulator@2=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000002>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
regulator-compatible=20=3D=20"dcdc3";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-name=20=3D=20=
"vdd_core";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20regulator-min-microvolt=20=3D=20<0x000e1d48>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
regulator-max-microvolt=20=3D=20<0x00118c30>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-boot-on;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
regulator-always-on;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000002b>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x0000002b>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
regulator@3=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20reg=20=3D=20<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-compatible=20=3D=20=
"ldo1";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20regulator-always-on;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000002c>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x0000002c>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20regulator@4=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000004>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-compatible=20=
=3D=20"ldo2";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20regulator-always-on;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000002d>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x0000002d>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20regulator@5=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000005>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-compatible=20=
=3D=20"ldo3";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20regulator-min-microvolt=20=3D=20<0x001b7740>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
regulator-max-microvolt=20=3D=20<0x00325aa0>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-always-on;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000005>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20<0x00000005>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator@6=20{=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000006>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20regulator-compatible=20=3D=20"ldo4";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20regulator-always-on;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000002e>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20<0x0000002e>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20=20=20=20=20baseboard_eeprom@50=20{=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"at,24c256";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000050>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000002f>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x0000002f>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
i2c@4802a000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"ti,omap4-i2c";=0A=20=20=20=20=20=20=20=20=20=20=20=20#address-cells=20=3D=
=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"i2c2";=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20<0x4802a000=20=
0x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupts=20=3D=20=
<0x00000047>;=0A=20=20=20=20=20=20=20=20=20=20=20=20status=20=3D=20=
"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000030>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000030>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
i2c@4819c000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"ti,omap4-i2c";=0A=20=20=20=20=20=20=20=20=20=20=20=20#address-cells=20=3D=
=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"i2c3";=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20<0x4819c000=20=
0x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupts=20=3D=20=
<0x0000001e>;=0A=20=20=20=20=20=20=20=20=20=20=20=20status=20=3D=20=
"okay";=0A=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20=
"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=3D=20=
<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=20=20clock-frequency=20=3D=20=
<0x000186a0>;=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x0000001d>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x0000001d>;=0A=20=20=20=20=20=20=20=20=20=20=20=20cape_eeprom_0@54=20{=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"at,24c256";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000054>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000000d>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x0000000d>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20cape_eeprom_1@55=20{=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"at,24c256";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000055>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000000e>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x0000000e>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20cape_eeprom_2@56=20{=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"at,24c256";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000056>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000000f>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x0000000f>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20cape_eeprom_3@57=20{=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"at,24c256";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x00000057>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000010>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x00000010>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
mmc@48060000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"ti,omap3-hsmmc";=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"mmc1";=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,dual-volt;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20ti,needs-special-reset;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20ti,needs-special-hs-handling;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20dmas=20=3D=20<0x00000004=200x00000018=200x00000004=200x00000019>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20dma-names=20=3D=20"tx",=20"rx";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20vmmc-supply=20=3D=20<0x00000005>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x00000031>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20<0x00000031>;=0A=20=20=20=20=
=20=20=20=20};=0A=20=20=20=20=20=20=20=20mmc@481d8000=20{=0A=20=20=20=20=20=
=20=20=20=20=20=20=20compatible=20=3D=20"ti,omap3-hsmmc";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20ti,hwmods=20=3D=20"mmc2";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20ti,needs-special-reset;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,needs-special-hs-handling;=0A=20=20=20=20=20=20=20=20=20=20=20=20dmas=20=
=3D=20<0x00000004=200x00000002=200x00000004=200x00000003>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20dma-names=20=3D=20"tx",=20"rx";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20vmmc-supply=20=3D=20<0x00000005>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20bus-width=20=3D=20<0x00000004>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20ti,non-removable;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20mmc@47810000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap3-hsmmc";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"mmc3";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,needs-special-reset;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,needs-special-hs-handling;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000033>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000033>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20phy0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=
=3D=20"nop-xceiv-usb";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000006>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000006>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20phy1=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=
=3D=20"nop-xceiv-usb";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000007>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000007>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20usb_otg_hs=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,musb-am33xx";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"usb_otg_hs";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
multipoint=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
num-eps=20=3D=20<0x00000010>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ram-bits=20=3D=20<0x0000000c>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
port0-mode=20=3D=20<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
port1-mode=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
power=20=3D=20<0x000000fa>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
usb0-phy=20=3D=20<0x00000006>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
usb1-phy=20=3D=20<0x00000007>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000034>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000034>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20rtc=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=
=20"ti,da830-rtc";=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"rtc";=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
spi@48030000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"ti,omap4-mcspi";=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"spi0";=0A=20=20=20=20=20=20=20=20=20=20=20=20#address-cells=20=3D=20=
<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x48030000=200x00000400>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20interrupt=20=3D=20<0x00000041>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
dmas=20=3D=20<0x00000004=200x00000010=200x00000004=200x00000011=20=
0x00000004=200x00000012=200x00000004=200x00000013>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20dma-names=20=3D=20"tx0",=20"rx0",=20"tx1",=20"rx1";=0A=20=20=
=20=20=20=20=20=20=20=20=20=20ti,spi-num-cs=20=3D=20<0x00000002>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x00000035>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20phandle=20=3D=20<0x00000035>;=0A=20=20=20=20=20=20=20=
=20};=0A=20=20=20=20=20=20=20=20spi@481a0000=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20compatible=20=3D=20"ti,omap4-mcspi";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20ti,hwmods=20=3D=20"spi1";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20#size-cells=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
reg=20=3D=20<0x481a0000=200x00000400>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt=20=3D=20<0x0000007d>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20dmas=20=3D=20<0x00000004=200x0000002a=200x00000004=200x0000002b=20=
0x00000004=200x0000002c=200x00000004=200x0000002d>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20dma-names=20=3D=20"tx0",=20"rx0",=20"tx1",=20"rx1";=0A=20=20=
=20=20=20=20=20=20=20=20=20=20ti,spi-num-cs=20=3D=20<0x00000002>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=
=20=20=20=20=20=20pinctrl-0=20=3D=20<0x00000008>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20linux,phandle=20=3D=20<0x00000020>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20phandle=20=3D=20<0x00000020>;=0A=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20wdt@44e35000=20{=0A=20=20=20=20=20=20=20=20=20=
=20=20=20compatible=20=3D=20"ti,omap3-wdt";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20ti,hwmods=20=3D=20"wd_timer2";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x44e35000=200x00001000>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20interrupts=20=3D=20<0x0000005b>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20linux,phandle=20=3D=20<0x00000036>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20phandle=20=3D=20<0x00000036>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20ethernet@4A100000=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20compatible=20=3D=20"ti,cpsw";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"cpgmac0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
cpdma_channels=20=3D=20<0x00000008>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
host_port_no=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
cpdma_reg_ofs=20=3D=20<0x00000800>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
cpdma_sram_ofs=20=3D=20<0x00000a00>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ale_reg_ofs=20=3D=20<0x00000d00>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ale_entries=20=3D=20<0x00000400>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
host_port_reg_ofs=20=3D=20<0x00000108>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20hw_stats_reg_ofs=20=3D=20<0x00000900>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20bd_ram_ofs=20=3D=20<0x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20bd_ram_size=20=3D=20<0x00002000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
no_bd_ram=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
rx_descs=20=3D=20<0x00000040>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
mac_control=20=3D=20<0x00000020>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
slaves=20=3D=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=
=3D=20<0x4a100000=200x00000800=200x4a101200=200x00000100=200x4a101000=20=
0x00000100>;=0A=20=20=20=20=20=20=20=20=20=20=20=20#address-cells=20=3D=20=
<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=
=20<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupts=20=3D=20=
<0x00000028=200x00000029=200x0000002a=200x0000002b>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20ranges;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000037>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000037>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
slave@0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
slave_reg_ofs=20=3D=20<0x00000208>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20sliver_reg_ofs=20=3D=20<0x00000d80>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20mac-address=20=3D=20[00=2000=2000=2000=2000=20=
00];=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20phy_id=20=3D=20=
"4a101000.mdio:00";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000038>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x00000038>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20slave@1=20{=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20slave_reg_ofs=20=3D=20<0x00000308>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20sliver_reg_ofs=20=3D=20=
<0x00000dc0>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
mac-address=20=3D=20[00=2000=2000=2000=2000=2000];=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20phy_id=20=3D=20"4a101000.mdio:01";=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000039>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=
=3D=20<0x00000039>;=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20=20=20=20=20mdio@4a101000=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20compatible=20=3D=20"ti,davinci_mdio";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"davinci_mdio";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20bus_freq=20=3D=20<0x000f4240>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20reg=20=3D=20<0x4a101000=200x00000100>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x0000003a>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20<0x0000003a>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20};=0A=20=
=20=20=20=20=20=20=20ehrpwm@48300200=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20compatible=20=3D=20"ti,omap2-ehrpwm";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20reg=20=3D=20<0x48300200=200x00000100=200x48300000=20=
0x00000010>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupt=20=3D=20=
<0x00000056=200x0000003a>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"ehrpwm0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
#pwm-cells=20=3D=20<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000003b>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x0000003b>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20ehrpwm@48302200=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap2-ehrpwm";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x48302200=200x00000100=200x48302000=200x00000010>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20interrupt=20=3D=20<0x00000057=20=
0x0000003b>;=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"ehrpwm1";=0A=20=20=20=20=20=20=20=20=20=20=20=20#pwm-cells=20=3D=20=
<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=20=20status=20=3D=20=
"okay";=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x00000015>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x00000015>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
ehrpwm@48304200=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=
=20"ti,omap2-ehrpwm";=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x48304200=200x00000100=200x48304000=200x00000010>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20interrupt=20=3D=20<0x00000027=200x0000003c>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"ehrpwm2";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20#pwm-cells=20=3D=20<0x00000003>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20linux,phandle=20=3D=20<0x0000003c>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x0000003c>;=0A=20=20=20=20=20=20=20=20};=0A=
=20=20=20=20=20=20=20=20ecap@48300100=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20compatible=20=3D=20"ti,omap2-ecap";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20reg=20=3D=20<0x48300100=200x00000080=200x48300000=200x00000010>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=20=
<0x00000002>;=0A=20=20=20=20=20=20=20=20=20=20=20=20interrupt=20=3D=20=
<0x0000001f>;=0A=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20=
"ecap0";=0A=20=20=20=20=20=20=20=20=20=20=20=20#pwm-cells=20=3D=20=
<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=20=20status=20=3D=20=
"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20=
<0x0000003d>;=0A=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20=
<0x0000003d>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
ecap@48302100=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"ti,omap2-ecap";=0A=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20=
<0x48302100=200x00000080=200x48302000=200x00000010>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20interrupt=20=3D=20<0x0000002f>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20ti,hwmods=20=3D=20"ecap1";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20#pwm-cells=20=3D=20<0x00000003>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x0000003e>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x0000003e>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20ecap@48304100=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti,omap2-ecap";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
reg=20=3D=20<0x48304100=200x00000080=200x48304000=200x00000010>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20interrupt-parent=20=3D=20<0x00000002>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20interrupt=20=3D=20<0x0000003d>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"ecap2";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20#pwm-cells=20=3D=20<0x00000003>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20status=20=3D=20"disabled";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20linux,phandle=20=3D=20<0x0000003f>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20phandle=20=3D=20<0x0000003f>;=0A=20=20=20=20=20=20=20=20};=0A=20=
=20=20=20=20=20=20=20gpio-leds=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"gpio-leds";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-0=20=3D=20<0x00000009>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
led0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20=
"beaglebone:green:usr0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
gpios=20=3D=20<0x0000000a=200x00000015=200x00000000>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20linux,default-trigger=20=3D=20"heartbeat";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=3D=20=
"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
=20=20=20=20led1=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
label=20=3D=20"beaglebone:green:usr1";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20gpios=20=3D=20<0x0000000a=200x00000016=200x00000000>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20linux,default-trigger=20=3D=20=
"mmc0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=
=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=
=20=20=20=20=20=20led2=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20label=20=3D=20"beaglebone:green:usr2";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20gpios=20=3D=20<0x0000000a=200x00000017=200x00000000>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20linux,default-trigger=20=
=3D=20"cpu0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
default-state=20=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=
=20=20=20=20=20=20=20=20=20=20=20led3=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20label=20=3D=20"beaglebone:green:usr3";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20<0x0000000a=200x00000018=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
default-state=20=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20linux,default-trigger=20=3D=20"mmc1";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20};=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20gpevt=20=
{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20"gpevt";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=
=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=3D=20<0x0000000b>;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20dmas=20=3D=20<0x00000004=200x0000000c>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20dma-names=20=3D=20"gpioevt";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20gpio-evt=20=3D=20<0x0000000c=200x00000002=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20};=0A=20=20=20=20=
capebus@0=20{=0A=20=20=20=20=20=20=20=20compatible=20=3D=20=
"bone-capebus";=0A=20=20=20=20=20=20=20=20slots=20=3D=20<0x0000000d=20=
0x0000000e=200x0000000f=200x00000010>;=0A=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000040>;=0A=20=20=20=20=20=20=20=20phandle=20=
=3D=20<0x00000040>;=0A=20=20=20=20=20=20=20=20cape@0=20{=0A=20=20=20=20=20=
=20=20=20=20=20=20=20compatible=20=3D=20"bone-generic-cape";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20board-name=20=3D=20"BeagleBone=20DVI-D=20CAPE";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x00000041>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20<0x00000041>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20version@00A0=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20version=20=3D=20"00A0";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20dvi=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20compatible=20=3D=20"da8xx-dt";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20"default";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=
=3D=20<0x00000011>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20ti,hwmods=20=3D=20"lcdc";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20disp-pll=20=3D=20<0x2160ec00>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20panel-type=20=3D=20=
"1024x768@60";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20powerdn-gpio=20=3D=20<0x0000000a=200x00000007=200x00000000>;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20version@00A1=20{=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20version=20=3D=20"00A1",=20"01";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20dvi=20{=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"da8xx-dt";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20pinctrl-0=20=3D=20<0x00000012>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"lcdc";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20disp-pll=20=3D=20=
<0x2160ec00>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20panel-type=20=3D=20"1024x768@60";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20powerdn-gpio=20=3D=20<0x0000000a=200x0000001f=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
gpio-leds=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"gpio-leds";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20pinctrl-0=20=3D=20<0x00000013>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20dvi-led0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20label=20=3D=20"dvi:green:usr0";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20=
<0x0000000a=200x00000012=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20linux,default-trigger=20=3D=20"heartbeat";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=
=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20dvi-led1=20{=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20=
"dvi:green:usr1";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20gpios=20=3D=20<0x0000000a=200x00000013=200x00000000>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20linux,default-trigger=20=
=3D=20"mmc0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20default-state=20=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20cape@1=20{=0A=20=20=20=20=20=20=20=20=20=
=20=20=20compatible=20=3D=20"bone-geiger-cape";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20board-name=20=3D=20"Geiger=20Cape";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20pinctrl-0=20=3D=20<0x00000014>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20pwms=20=3D=20<0x00000015=200x00000000=200x0007a120=200x00000000>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20pwm-names=20=3D=20=
"bone-geiger-cape";=0A=20=20=20=20=20=20=20=20=20=20=20=20pwm-frequency=20=
=3D=20<0x00004e20>;=0A=20=20=20=20=20=20=20=20=20=20=20=20pwm-duty-cycle=20=
=3D=20<0x0000003c>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
event-blink-delay=20=3D=20<0x0000001e>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20gpios=20=3D=20<0x00000016=200x00000011=200x00000000>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20vsense-name=20=3D=20"AIN5";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20vsense-scale=20=3D=20<0x000091cd>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20linux,phandle=20=3D=20<0x00000042>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x00000042>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20tscadc=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"ti-tscadc-dt";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20ti,hwmods=20=3D=20"adc_tsc";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20adc-channels=20=3D=20<0x00000008>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20gpio-leds=20{=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"gpio-leds";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20pinctrl-0=20=3D=20<0x00000017>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20geiger-led0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20label=20=3D=20"geiger:green:usr0";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20<0x0000000c=20=
0x00000017=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20linux,default-trigger=20=3D=20"geiger-run";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=3D=20=
"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20geiger-led1=20{=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20"geiger:red:usr1";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20=
<0x0000000c=200x00000019=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20linux,default-trigger=20=3D=20"geiger-event";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
default-state=20=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=
=20};=0A=20=20=20=20=20=20=20=20cape@2=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20compatible=20=3D=20"bone-generic-cape";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20board-name=20=3D=20"BeagleBone=20LCD3=20CAPE";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x00000043>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20phandle=20=3D=20<0x00000043>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20lcd3=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"da8xx-dt";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20pinctrl-0=20=3D=20<0x00000018>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"lcdc";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20disp-pll=20=3D=20<0x00f42400>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20panel-type=20=3D=20"CDTech_S035Q01";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
tscadc=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=
=3D=20"ti-tscadc-dt";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
ti,hwmods=20=3D=20"adc_tsc";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20tsc-wires=20=3D=20<0x00000004>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20tsc-x-plate-resistance=20=3D=20<0x000000c8>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20tsc-steps=20=3D=20<0x00000006>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20adc-channels=20=3D=20=
<0x00000004>;=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=
=20=20=20=20=20=20version@00A0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20version=20=3D=20"00A0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20backlight=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20compatible=20=3D=20"tps65217-backlight";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20isel=20=3D=20<0x00000001>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20fdim=20=3D=20=
<0x000000c8>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20tps=20=3D=20<0x00000019>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20brightness=20=3D=20<0x00000064>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20gpio-leds=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20compatible=20=3D=20"gpio-leds";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=3D=20=
<0x0000001a>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20lcd3-led0=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20label=20=3D=20"lcd3:green:usr0";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20=
<0x0000000a=200x00000012=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20linux,default-trigger=20=3D=20=
"heartbeat";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20default-state=20=3D=20"off";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20lcd3-led1=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20"lcd3:green:usr1";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
gpios=20=3D=20<0x0000000a=200x00000013=200x00000000>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,default-trigger=20=3D=20"cpu0";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=3D=20"off";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20gpio_keys=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20compatible=20=3D=20"gpio-keys";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20"default";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=
=3D=20<0x0000001b>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20<0x00000000>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20button@1=20{=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
debounce_interval=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20linux,code=20=3D=20<0x00000069>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
label=20=3D=20"left";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20gpios=20=3D=20<0x0000000a=200x00000010=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20autorepeat;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20button@2=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20debounce_interval=20=3D=20<0x00000032>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,code=20=3D=20<0x0000006a>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20"right";=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20=
<0x0000000a=200x00000011=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20autorepeat;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20button@3=20{=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
debounce_interval=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20linux,code=20=3D=20<0x00000067>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
label=20=3D=20"up";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20gpios=20=3D=20<0x00000016=200x00000013=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20autorepeat;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20button@4=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20debounce_interval=20=3D=20<0x00000032>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,code=20=3D=20<0x0000006c>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20"down";=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20=
<0x0000000a=200x0000001c=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20autorepeat;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20button@5=20{=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
debounce_interval=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20linux,code=20=3D=20<0x0000001c>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
label=20=3D=20"enter";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20gpios=20=3D=20<0x0000001c=200x00000007=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20};=0A=
=20=20=20=20=20=20=20=20cape@3=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"bone-lcd7-cape";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
board-name=20=3D=20"BeagleBone=20LCD7=20CAPE";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20linux,phandle=20=3D=20<0x00000044>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20phandle=20=3D=20<0x00000044>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20lcd7=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"da8xx-dt";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20pinctrl-0=20=3D=20<0x00000018>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"lcdc";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20disp-pll=20=3D=20<0x03938700>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20panel-type=20=3D=20=
"TFC_S9700RTWV35TR_01B";=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20=20=20=20=20tscadc=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20compatible=20=3D=20"ti-tscadc-dt";=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20ti,hwmods=20=3D=20"adc_tsc";=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20tsc-wires=20=3D=20<0x00000004>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20tsc-x-plate-resistance=20=3D=20=
<0x000000c8>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
tsc-steps=20=3D=20<0x00000006>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20adc-channels=20=3D=20<0x00000004>;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20version@00A0=20{=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20version=20=3D=20"00A0";=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20backlight=20{=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"tps65217-backlight";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20isel=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20fdim=20=3D=20<0x000000c8>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20tps=20=3D=20<0x00000019>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20brightness=20=3D=20=
<0x00000064>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpio-leds=20{=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"gpio-leds";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20pinctrl-0=20=3D=20<0x0000001a>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20lcd3-led0=20{=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20=
"lcd3:green:usr0";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20gpios=20=3D=20<0x0000000a=200x00000012=200x00000000>;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
linux,default-trigger=20=3D=20"heartbeat";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=3D=20"off";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20lcd3-led1=20{=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=
=3D=20"lcd3:green:usr1";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20gpios=20=3D=20<0x0000000a=200x00000013=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20linux,default-trigger=20=3D=20"cpu0";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20default-state=20=3D=20=
"off";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20gpio_keys=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20"gpio-keys";=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20=
"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
pinctrl-0=20=3D=20<0x0000001b>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20=
<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20button@1=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20debounce_interval=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20linux,code=20=3D=20=
<0x00000069>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20label=20=3D=20"left";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20<0x0000000a=20=
0x00000010=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20autorepeat;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20button@2=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20debounce_interval=20=3D=20=
<0x00000032>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20linux,code=20=3D=20<0x0000006a>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20"right";=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
gpios=20=3D=20<0x0000000a=200x00000011=200x00000000>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
autorepeat;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
button@3=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20debounce_interval=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20linux,code=20=3D=20=
<0x00000067>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20label=20=3D=20"up";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20<0x00000016=20=
0x00000013=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20autorepeat;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20button@4=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20debounce_interval=20=3D=20=
<0x00000032>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20linux,code=20=3D=20<0x0000006c>;=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20label=20=3D=20"down";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
gpios=20=3D=20<0x0000000a=200x0000001c=200x00000000>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
autorepeat;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
button@5=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20debounce_interval=20=3D=20<0x00000032>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20linux,code=20=3D=20=
<0x0000001c>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20label=20=3D=20"enter";=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20gpios=20=3D=20<0x0000001c=20=
0x00000007=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20gpio-key,wakeup;=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=
=20=20=20};=0A=20=20=20=20=20=20=20=20cape@4=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20compatible=20=3D=20"bone-generic-cape";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20board-name=20=3D=20"BeagleBone=20Weather=20CAPE";=0A=20=20=
=20=20=20=20=20=20=20=20=20=20linux,phandle=20=3D=20<0x00000045>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20phandle=20=3D=20<0x00000045>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20i2c2-devices=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20compatible=20=3D=20"i2c-dt";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20#size-cells=20=3D=20<0x00000000>;=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20parent=20=3D=20=
<0x0000001d>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
tsl2550@39=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20compatible=20=3D=20"tsl,tsl2550";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000039>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20sht21@40=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20compatible=20=3D=20"sensiron,sht21";=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000040>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20bmp085@77=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20compatible=20=3D=20"bosch,bmp085";=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20reg=20=3D=20<0x00000077>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=
=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20onewire@0=20{=0A=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20"w1-gpio";=0A=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-names=20=3D=20=
"default";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=
=3D=20<0x0000001e>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
status=20=3D=20"okay";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
gpios=20=3D=20<0x0000000a=200x00000003=200x00000000>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=
=20cape@5=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"bone-generic-cape";=0A=20=20=20=20=20=20=20=20=20=20=20=20board-name=20=
=3D=20"Adafruit=201.8=20Cape";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
linux,phandle=20=3D=20<0x00000046>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
phandle=20=3D=20<0x00000046>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=
backlight=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"pwm-backlight";=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20pinctrl-0=20=3D=20<0x0000001f>;=0A=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20pwms=20=3D=20<0x00000015=200x00000001=20=
0x0007a120=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20pwm-names=20=3D=20"st7735fb";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20brightness-levels=20=3D=20<0x00000000=200x00000001=200x00000002=20=
0x00000003=200x00000004=200x00000005=200x00000006=200x00000007=20=
0x00000008=200x00000009=200x0000000a=200x0000000b=200x0000000c=20=
0x0000000d=200x0000000e=200x0000000f=200x00000010=200x00000011=20=
0x00000012=200x00000013=200x00000014=200x00000015=200x00000016=20=
0x00000017=200x00000018=200x00000019=200x0000001a=200x0000001b=20=
0x0000001c=200x0000001d=200x0000001e=200x0000001f=200x00000020=20=
0x00000021=200x00000022=200x00000023=200x00000024=200x00000025=20=
0x00000026=200x00000027=200x00000028=200x00000029=200x0000002a=20=
0x0000002b=200x0000002c=200x0000002d=200x0000002e=200x0000002f=20=
0x00000030=200x00000031=200x00000032=200x00000033=200x00000034=20=
0x00000035=200x00000036=200x00000037=200x00000038=200x00000039=20=
0x0000003a=200x0000003b=200x0000003c=200x0000003d=200x0000003e=20=
0x0000003f=200x00000040=200x00000041=200x00000042=200x00000043=20=
0x00000044=200x00000045=200x00000046=200x00000047=200x00000048=20=
0x00000049=200x0000004a=200x0000004b=200x0000004c=200x0000004d=20=
0x0000004e=200x0000004f=200x00000050=200x00000051=200x00000052=20=
0x00000053=200x00000054=200x00000055=200x00000056=200x00000057=20=
0x00000058=200x00000059=200x0000005a=200x0000005b=200x0000005c=20=
0x0000005d=200x0000005e=200x0000005f=200x00000060=200x00000061=20=
0x00000062=200x00000063=200x00000064>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20default-brightness-level=20=3D=20<0x00000032>;=0A=20=20=20=
=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20=20=20=20=20=
spi1-devices=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
compatible=20=3D=20"spi-dt";=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20#address-cells=20=3D=20<0x00000001>;=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20#size-cells=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20parent=20=3D=20<0x00000020>;=0A=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20lcd@0=20{=0A=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20compatible=20=3D=20=
"adafruit,tft-lcd-1.8-red",=20"sitronix,st7735";=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20spi-max-frequency=20=3D=20=
<0x007a1200>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20reg=20=3D=20<0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20spi-cpol;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20spi-cpha;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20pinctrl-names=20=3D=20"default";=0A=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20pinctrl-0=20=3D=20<0x00000021>;=0A=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20st7735-rst=20=3D=20=
<0x00000016=200x00000013=200x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20st7735-dc=20=3D=20<0x00000016=200x00000015=20=
0x00000000>;=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20};=0A=20=20=
=20=20=20=20=20=20=20=20=20=20};=0A=20=20=20=20=20=20=20=20};=0A=20=20=20=
=20};=0A=20=20=20=20@symbols@=20{=0A=20=20=20=20=20=20=20=20=
am3358_pinmux=20=3D=20"/pinmux@44e10800";=0A=20=20=20=20=20=20=20=20=
spi1_pins=20=3D=20"/pinmux@44e10800/pinmux_spi1_pins";=0A=20=20=20=20=20=20=
=20=20lcd_pins=20=3D=20"/pinmux@44e10800/pinmux_lcd_pins";=0A=20=20=20=20=
=20=20=20=20gpevt_pins=20=3D=20"/pinmux@44e10800/pinmux_gpevt_pins";=0A=20=
=20=20=20=20=20=20=20userled_pins=20=3D=20=
"/pinmux@44e10800/pinmux_userled_pins";=0A=20=20=20=20=20=20=20=20=
i2c2_pins=20=3D=20"/pinmux@44e10800/pinmux_i2c2_pins";=0A=20=20=20=20=20=20=
=20=20bone_dvi_cape_led_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_dvi_cape_led_pins";=0A=20=20=20=20=20=20=20=
=20bone_dvi_cape_dvi_00A0_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_dvi_cape_dvi_00A0_pins";=0A=20=20=20=20=20=20=
=20=20bone_dvi_cape_dvi_00A1_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_dvi_cape_dvi_00A1_pins";=0A=20=20=20=20=20=20=
=20=20bone_geiger_cape_led_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_geiger_cape_led_pins";=0A=20=20=20=20=20=20=
=20=20bone_geiger_cape_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_geiger_cape_pins";=0A=20=20=20=20=20=20=20=20=
bone_lcd3_cape_led_00A0_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_lcd3_cape_led_00A0_pins";=0A=20=20=20=20=20=
=20=20=20bone_lcd3_cape_lcd_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_lcd3_cape_lcd_pins";=0A=20=20=20=20=20=20=20=
=20bone_lcd3_cape_keys_00A0_pins=20=3D=20=
"/pinmux@44e10800/pinmux_bone_lcd3_cape_keys_00A0_pins";=0A=20=20=20=20=20=
=20=20=20pwm_bl_pins=20=3D=20"/pinmux@44e10800/pinmux_pwm_bl_pins";=0A=20=
=20=20=20=20=20=20=20weather_cape_w1_pins=20=3D=20=
"/pinmux@44e10800/pinmux_weather_cape_w1_pins";=0A=20=20=20=20=20=20=20=20=
intc=20=3D=20"/ocp/interrupt-controller@48200000";=0A=20=20=20=20=20=20=20=
=20edma=20=3D=20"/ocp/edma@49000000";=0A=20=20=20=20=20=20=20=20gpio1=20=
=3D=20"/ocp/gpio@44e07000";=0A=20=20=20=20=20=20=20=20gpio2=20=3D=20=
"/ocp/gpio@4804c000";=0A=20=20=20=20=20=20=20=20gpio3=20=3D=20=
"/ocp/gpio@481ac000";=0A=20=20=20=20=20=20=20=20gpio4=20=3D=20=
"/ocp/gpio@481ae000";=0A=20=20=20=20=20=20=20=20uart1=20=3D=20=
"/ocp/serial@44e09000";=0A=20=20=20=20=20=20=20=20uart2=20=3D=20=
"/ocp/serial@48022000";=0A=20=20=20=20=20=20=20=20uart3=20=3D=20=
"/ocp/serial@48024000";=0A=20=20=20=20=20=20=20=20uart4=20=3D=20=
"/ocp/serial@481a6000";=0A=20=20=20=20=20=20=20=20uart5=20=3D=20=
"/ocp/serial@481a8000";=0A=20=20=20=20=20=20=20=20uart6=20=3D=20=
"/ocp/serial@481aa000";=0A=20=20=20=20=20=20=20=20i2c0=20=3D=20=
"/ocp/i2c@44e0b000";=0A=20=20=20=20=20=20=20=20tps=20=3D=20=
"/ocp/i2c@44e0b000/tps@24";=0A=20=20=20=20=20=20=20=20dcdc1_reg=20=3D=20=
"/ocp/i2c@44e0b000/tps@24/regulators/regulator@0";=0A=20=20=20=20=20=20=20=
=20dcdc2_reg=20=3D=20"/ocp/i2c@44e0b000/tps@24/regulators/regulator@1";=0A=
=20=20=20=20=20=20=20=20dcdc3_reg=20=3D=20=
"/ocp/i2c@44e0b000/tps@24/regulators/regulator@2";=0A=20=20=20=20=20=20=20=
=20ldo1_reg=20=3D=20"/ocp/i2c@44e0b000/tps@24/regulators/regulator@3";=0A=
=20=20=20=20=20=20=20=20ldo2_reg=20=3D=20=
"/ocp/i2c@44e0b000/tps@24/regulators/regulator@4";=0A=20=20=20=20=20=20=20=
=20ldo3_reg=20=3D=20"/ocp/i2c@44e0b000/tps@24/regulators/regulator@5";=0A=
=20=20=20=20=20=20=20=20ldo4_reg=20=3D=20=
"/ocp/i2c@44e0b000/tps@24/regulators/regulator@6";=0A=20=20=20=20=20=20=20=
=20baseboard_eeprom=20=3D=20"/ocp/i2c@44e0b000/baseboard_eeprom@50";=0A=20=
=20=20=20=20=20=20=20i2c1=20=3D=20"/ocp/i2c@4802a000";=0A=20=20=20=20=20=20=
=20=20i2c2=20=3D=20"/ocp/i2c@4819c000";=0A=20=20=20=20=20=20=20=20=
cape_eeprom_0=20=3D=20"/ocp/i2c@4819c000/cape_eeprom_0@54";=0A=20=20=20=20=
=20=20=20=20cape_eeprom_1=20=3D=20"/ocp/i2c@4819c000/cape_eeprom_1@55";=0A=
=20=20=20=20=20=20=20=20cape_eeprom_2=20=3D=20=
"/ocp/i2c@4819c000/cape_eeprom_2@56";=0A=20=20=20=20=20=20=20=20=
cape_eeprom_3=20=3D=20"/ocp/i2c@4819c000/cape_eeprom_3@57";=0A=20=20=20=20=
=20=20=20=20mmc1=20=3D=20"/ocp/mmc@48060000";=0A=20=20=20=20=20=20=20=20=
mmc2=20=3D=20"/ocp/mmc@481d8000";=0A=20=20=20=20=20=20=20=20mmc3=20=3D=20=
"/ocp/mmc@47810000";=0A=20=20=20=20=20=20=20=20usb0_phy=20=3D=20=
"/ocp/phy0";=0A=20=20=20=20=20=20=20=20usb1_phy=20=3D=20"/ocp/phy1";=0A=20=
=20=20=20=20=20=20=20usb_otg_hs=20=3D=20"/ocp/usb_otg_hs";=0A=20=20=20=20=
=20=20=20=20spi0=20=3D=20"/ocp/spi@48030000";=0A=20=20=20=20=20=20=20=20=
spi1=20=3D=20"/ocp/spi@481a0000";=0A=20=20=20=20=20=20=20=20wdt2=20=3D=20=
"/ocp/wdt@44e35000";=0A=20=20=20=20=20=20=20=20mac=20=3D=20=
"/ocp/ethernet@4A100000";=0A=20=20=20=20=20=20=20=20cpsw_emac0=20=3D=20=
"/ocp/ethernet@4A100000/slave@0";=0A=20=20=20=20=20=20=20=20cpsw_emac1=20=
=3D=20"/ocp/ethernet@4A100000/slave@1";=0A=20=20=20=20=20=20=20=20=
davinci_mdio=20=3D=20"/ocp/ethernet@4A100000/mdio@4a101000";=0A=20=20=20=20=
=20=20=20=20ehrpwm0=20=3D=20"/ocp/ehrpwm@48300200";=0A=20=20=20=20=20=20=20=
=20ehrpwm1=20=3D=20"/ocp/ehrpwm@48302200";=0A=20=20=20=20=20=20=20=20=
ehrpwm2=20=3D=20"/ocp/ehrpwm@48304200";=0A=20=20=20=20=20=20=20=20ecap0=20=
=3D=20"/ocp/ecap@48300100";=0A=20=20=20=20=20=20=20=20ecap1=20=3D=20=
"/ocp/ecap@48302100";=0A=20=20=20=20=20=20=20=20ecap2=20=3D=20=
"/ocp/ecap@48304100";=0A=20=20=20=20=20=20=20=20capebus=20=3D=20=
"/capebus@0";=0A=20=20=20=20=20=20=20=20bone_dvi_cape=20=3D=20=
"/capebus@0/cape@0";=0A=20=20=20=20=20=20=20=20bone_geiger_cape=20=3D=20=
"/capebus@0/cape@1";=0A=20=20=20=20=20=20=20=20bone_lcd3_cape=20=3D=20=
"/capebus@0/cape@2";=0A=20=20=20=20=20=20=20=20bone_lcd7_cape=20=3D=20=
"/capebus@0/cape@3";=0A=20=20=20=20=20=20=20=20bone_weather_cape=20=3D=20=
"/capebus@0/cape@4";=0A=20=20=20=20=20=20=20=20bone_adafruit_cape=20=3D=20=
"/capebus@0/cape@5";=0A=20=20=20=20};=0A};=0A=

--Apple-Mail-6-881890762--
